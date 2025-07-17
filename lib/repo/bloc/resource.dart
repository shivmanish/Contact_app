part of contact_app;

abstract class ContactResourceBloc<O>
    extends Bloc<ContactResourceEvent, ContactResourceState> {
  Future<O?> fetch(ContactResourceFetchEvent event);
  Future<ContactListApiResponse<O>?> list(ContactResourceListEvent event);
  Future<O?> create(ContactResourceCreateEvent event);
  Future delete(ContactResourceDeleteEvent event);
  Future<O?> sync(ContactResourceSyncEvent event);

  ContactResourceBloc()
    : super(ContactResourceInitialState(event: ContactResourceInitialEvent())) {
    on((event, emit) async {
      if (event is ContactResourceFetchEvent) {
        await _onFetchEvent(event, emit);
      } else if (event is ContactResourceListEvent) {
        await _onListEvent(event, emit);
      } else if (event is ContactResourceCreateEvent) {
        await _onCreateEvent(event, emit);
      } else if (event is ContactResourceDeleteEvent) {
        await _onDeleteEvent(event, emit);
      } else if (event is ContactResourceSyncEvent) {
        await _onSyncEvent(event, emit);
      } else {
        throw Exception('Unknown event ${event.toString()}');
      }
    });
  }

  Future<void> _onFetchEvent(
    ContactResourceFetchEvent event,
    Emitter<ContactResourceState> emit,
  ) async {
    try {
      emit(ContactResourceFetchingState(event: event));
      final response = await fetch(event);
      if (response == null) {
        emit(ContactResourceErrorState(1001, message: 'IsNull', event: event));
      } else {
        emit(ContactResourceFetchedState<O>(response, event: event));
      }
    } catch (e) {
      emit(
        ContactResourceErrorState(
          1000,
          message: 'UnknownException',
          event: event,
        ),
      );
    }
  }

  Future<void> _onListEvent(
    ContactResourceListEvent event,
    Emitter<ContactResourceState> emit,
  ) async {
    try {
      if (state is ContactResourceInitialState || event.offset == 0) {
        emit(ContactResourceListingState(event: event));
      }
      final response = await list(event);
      if (response == null) {
        emit(ContactResourceErrorState(1001, message: 'IsNull', event: event));
      } else {
        emit(ContactResourceListedState<O>(response, event: event));
      }
    } catch (e) {
      emit(
        ContactResourceErrorState(
          1000,
          message: 'UnknownException',
          event: event,
        ),
      );
    }
  }

  Future<void> _onCreateEvent(
    ContactResourceCreateEvent event,
    Emitter<ContactResourceState> emit,
  ) async {
    try {
      emit(ContactResourceCreatingState(event: event));
      final response = await create(event);
      if (response == null) {
        emit(ContactResourceErrorState(1001, message: 'IsNull', event: event));
      } else {
        emit(ContactResourceCreatedState<O>(response, event: event));
      }
    } catch (e) {
      emit(
        ContactResourceErrorState(
          1000,
          message: 'UnknownException',
          event: event,
        ),
      );
    }
  }

  Future<void> _onSyncEvent(
    ContactResourceSyncEvent event,
    Emitter<ContactResourceState> emit,
  ) async {
    try {
      emit(ContactResourceSyncingState(event: event));
      final response = await sync(event);
      if (response == null) {
        emit(ContactResourceErrorState(1001, message: 'IsNull', event: event));
      } else {
        emit(ContactResourceSyncedState<O>(response, event: event));
      }
    } catch (e) {
      emit(
        ContactResourceErrorState(
          1000,
          message: 'UnknownException',
          event: event,
        ),
      );
    }
  }

  Future<void> _onDeleteEvent(
    ContactResourceDeleteEvent event,
    Emitter<ContactResourceState> emit,
  ) async {
    // try {
    emit(ContactResourceDeletingState(event: event));
    // ignore: unused_local_variable
    final response = await delete(event);

    emit(ContactResourceDeletedState<O>(event: event));
    // } catch (e) {
    //   emit(
    //     ContactResourceErrorState(
    //       1000,
    //       message: 'UnknownException',
    //       event: event,
    //     ),
    //   );
    // }
  }
}
