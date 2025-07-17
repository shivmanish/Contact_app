part of contact_app;

abstract class ContactResourceState extends Equatable {
  final ContactResourceEvent event;

  const ContactResourceState({required this.event});

  @override
  List<Object> get props => [event];
}

// initial

class ContactResourceInitialState extends ContactResourceState {
  const ContactResourceInitialState({required super.event});
}

// Error
class ContactResourceErrorState extends ContactResourceState {
  final int code;
  final String? message;

  const ContactResourceErrorState(
    this.code, {
    required super.event,
    this.message,
  });
}

// create object
class ContactResourceCreatingState extends ContactResourceState {
  const ContactResourceCreatingState({required super.event});
}

class ContactResourceCreatedState<O> extends ContactResourceState {
  final O resource;

  const ContactResourceCreatedState(this.resource, {required super.event});

  @override
  List<Object> get props => [resource.hashCode];
}

// delete object
class ContactResourceDeletingState extends ContactResourceState {
  const ContactResourceDeletingState({required super.event});
}

class ContactResourceDeletedState<O> extends ContactResourceState {
  const ContactResourceDeletedState({required super.event});
}

// fetch object
class ContactResourceFetchingState extends ContactResourceState {
  const ContactResourceFetchingState({required super.event});
}

class ContactResourceFetchedState<O> extends ContactResourceState {
  final O resource;

  const ContactResourceFetchedState(this.resource, {required super.event});
}

//list objects
class ContactResourceListingState extends ContactResourceState {
  const ContactResourceListingState({required super.event});
}

class ContactResourceListedState<O> extends ContactResourceState {
  final ContactListApiResponse<O> response;

  const ContactResourceListedState(this.response, {required super.event});

  @override
  List<Object> get props => [response];
}

//sync
class ContactResourceSyncingState extends ContactResourceState {
  const ContactResourceSyncingState({required super.event});
}

class ContactResourceSyncedState<O> extends ContactResourceState {
  final O resource;

  const ContactResourceSyncedState(this.resource, {required super.event});

  @override
  List<Object> get props => [resource.hashCode];
}
