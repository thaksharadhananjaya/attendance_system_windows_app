part of 'guest_bloc.dart';

@immutable
abstract class GuestState {}

class GuestInitial extends GuestState {}

class LoadedGuest extends GuestState{
  final List<Guest> guestList;
  LoadedGuest({this.guestList});
  List<Object> get props => [this.guestList];
}


class GuestErrorState extends GuestState{
  final String message;
  GuestErrorState({this.message});
  List<Object> get props => [this.message];
}
