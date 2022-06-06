
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/guest_model.dart';
import '../respositories/guest_respo.dart';

part 'guest_event.dart';
part 'guest_state.dart';

class GuestBloc extends Bloc<GuestEvent, GuestState> {
  final int isAttend;
  final String search;
  GuestBloc(this.isAttend, this.search)
      : super(GuestInitial());
  List<Guest> guestList = [];
  GuestRepo guestRepo = GuestRepo();
  int page = -5;
  bool isLoading = false;
  @override
  Stream<GuestState> mapEventToState(GuestEvent event) async* {
    if (event is FetchGuest) {
      if (!isLoading) {
        isLoading = true;
        page += 5;
        List<Guest> list =
            await guestRepo.getGuest(isAttend, page, search);
        try {
          if (list == null) {
            if (guestList.length > 0) {
              page -= 5;
              yield LoadedGuest(guestList: guestList);
            } else {
              yield search != null
                  ? GuestErrorState(message: "Search result not found !")
                  : GuestErrorState(message: "Not found guest");
            }
          } else {
            guestList.addAll(list);
            yield LoadedGuest(guestList: guestList);
          }
        } catch (e) {
          page -= 5;
          yield GuestErrorState(message: "Error !");
        }
        isLoading = false;
      }
    } else if (event is ReloadGuest) {
      yield null;
      guestList.clear();
      List<Guest> list =
          await guestRepo.getGuest(isAttend, 0, search);
      try {
        if (list == null) {
          yield GuestErrorState(message: "Empty");
        } else {
          guestList.addAll(list);
          yield LoadedGuest(guestList: guestList);
        }
      } catch (e) {
        yield GuestErrorState(message: "Error !");
      }
    }
  }
}
