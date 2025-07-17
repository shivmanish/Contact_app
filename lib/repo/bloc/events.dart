part of contact_app;

abstract class ContactResourceEvent extends Equatable {
  const ContactResourceEvent();

  @override
  List<Object> get props => [];
}

class ContactResourceInitialEvent extends ContactResourceEvent {}

class ContactResourceCreateEvent extends ContactResourceEvent {
  final dynamic payload;

  const ContactResourceCreateEvent(this.payload);

  @override
  List<Object> get props => [payload];
}

class ContactResourceDeleteEvent extends ContactResourceEvent {
  final dynamic object;

  const ContactResourceDeleteEvent({required this.object});

  @override
  List<Object> get props => [object.hashCode];
}

class ContactResourceFetchEvent extends ContactResourceEvent {
  final int id;

  const ContactResourceFetchEvent({required this.id});

  @override
  List<Object> get props => [id];
}

abstract class ContactResourceListEvent extends ContactResourceEvent {
  final int limit;
  final int offset;

  const ContactResourceListEvent({required this.limit, required this.offset});

  @override
  List<Object> get props => [limit, offset];
}

class ContactResourceSyncEvent extends ContactResourceEvent {
  final dynamic object;

  const ContactResourceSyncEvent({required this.object});

  @override
  List<Object> get props => [object.hashCode];
}
