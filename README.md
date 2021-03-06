[![Codemagic build status](https://api.codemagic.io/apps/5cb1f56a4ea08100147dbe4e/5cb1f56a4ea08100147dbe4d/status_badge.svg)](https://codemagic.io/apps/5cb1f56a4ea08100147dbe4e/5cb1f56a4ea08100147dbe4d/latest_build)

# Vicinia

The main user experience of the [Vicinia](https://vicinia.net) service written in 24 hours at [PackHacks 2019](http://ncsupackhacks.org/).

## Photos

<img src="https://vicinia.net/img/mobile_01.2765fb34.webp" alt="Vicinia Splash Photo" width="250"/><img src="https://vicinia.net/img/mobile_02.e0ca32d0.webp" alt="Vicinia Username Photo" width="250"/><img src="https://vicinia.net/img/mobile_04.5f60fc8e.webp" alt="Vicinia Chat Photo" width="250"/>


## Team Members

- [Francesco Hayes](https://github.com/francesco-hayes): Web Developer
- [Boston Cartwright](https://github.com/munkurious): Mobile App Developer
- [Tyler Smith](https://github.com/tylerssmith): Backend Developer
- [Michelle Charette](https://github.com/theManMitch): "Math Guy" on Backend Developer

## Description

This app is written on the Flutter framework entirely in the Dart language. It takes advantage of of the BLoC design pattern, in order to keep the business logic seperated from the presentation layer, utilizing asyncronous streams. It also utilizes the repository pattern which helped greatly with testing and UI development. It also incorporates [built_value](https://pub.dartlang.org/packages/built_value) in order to provide immutable value types.

## DevOps

In order to implement our DevOps pipeline for CI, we utilized [codemagic](https://codemagic.io/start/). Though it currently doesn't deploy to any sources, it is very easy to set it up if we decide to release it on the available channels.
