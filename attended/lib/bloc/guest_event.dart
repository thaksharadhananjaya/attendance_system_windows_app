part of 'guest_bloc.dart';

@immutable
abstract class GuestEvent {}

class FetchGuest extends GuestEvent{
  FetchGuest();
}

class ReloadGuest extends GuestEvent{
  ReloadGuest();
}
