import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'bloc.dart';

import '../models/models.dart';
import '../utils/utils.dart';
import '../repository/repository.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ViciniaRepository repository;
  final String username;
  Location location;
  String placemark = '';
  int id = 0;

  ChatBloc({@required this.username, @required this.repository}) : super();

  Future<void> _updateLocation() async {
    location = await getCurrentLocation();
    var placem = await getPlacemarkFromLocation(location);
    placemark = placem.thoroughfare;
    if (placemark.isEmpty) {
      placemark = placem.administrativeArea;
    }
    _locationLoop();
  }

  void _locationLoop() async {
    await Future.delayed(Duration(seconds: 5));
    _updateLocation();
  }

  @override
  ChatState get initialState => InitialChatState();

  @override
  Stream<ChatState> mapEventToState(
    ChatEvent event,
  ) async* {
    if (event is Refresh) {
      yield LoadingChatState();
      this.dispatch(Fetch());
    }
    if (event is Fetch && !_hasReachedMax(currentState)) {
      try {
        if (currentState is InitialChatState ||
            currentState is LoadingChatState) {
          yield LoadingChatState();
          final messages = await _fetchMessages();
          yield LoadedChatState(
              messages: messages,
              hasReachedMax: false,
              location: location,
              placemark: placemark);
          _fetchInFuture();
          return;
        }
        if (currentState is LoadedChatState) {
          // TODO make it so we don't fetch ALL messages each time
          final messages = await _fetchMessages();
          if (messages == null || messages.isEmpty) {
            yield EmptyChatState();
            _fetchInFuture();
          }
          yield LoadedChatState(
              messages: messages,
              hasReachedMax: false,
              placemark: placemark,
              location: location);
          _fetchInFuture();
          return;
        }
      } catch (_) {
        yield ErrorChatState();
        _fetchInFuture();
      }
    }
    if (event is Send) {
      var message = Message.fromJson(
          '{ "id":"123${id++}", "name":"$username", "text":"${event.message}", "time":"${DateTime.now().toIso8601String()}", "location":{ "long":${location.long}, "lat":${location.lat} } }');
      final sent = await repository.createMessage(message);
      if (!sent) {
        // handle error
      }
      this.dispatch(Fetch());
    }
  }

  Future<void> _fetchInFuture() async {
    await Future.delayed(Duration(seconds: 2));
    this.dispatch(Fetch());
    // some crazyness for testing dd
    //   await Future.delayed(Duration(seconds: 2));
    //   var rng = Random();
    //   repository.createMessage(Message.fromJson(
    //       '{ "id":"123445667${rng.nextInt(10000000)}", "name":"CoooolDude!", "text":"Mitchel is the hottest man I\'ve ever met, except for Francesco!", "time":"2018-09-17T00:07:57Z", "location": { "long":34.232, "lat":23.55 } }'));
  }

  bool _hasReachedMax(ChatState state) =>
      state is LoadedChatState && state.hasReachedMax;

  Future<List<Message>> _fetchMessages() async {
    if (location == null) {
      await _updateLocation();
    }
    var messages = await repository.getMessages(location);
    return messages;
  }
}
