part of contact_app;

class ContactListEvent extends ContactResourceListEvent {
  final bool isFavorite;

  const ContactListEvent({
    required super.limit,
    required super.offset,
    this.isFavorite = false,
  });
}

class ContactCreateEvent extends ContactResourceCreateEvent {
  final ContactStoreModel contact;

  const ContactCreateEvent({required this.contact}) : super(contact);
}

class ContactSyncEvent extends ContactResourceSyncEvent {
  final bool? isFavorite;
  final ContactStoreModel contect;
  const ContactSyncEvent({required this.contect, this.isFavorite})
    : super(object: contect);
}

class ContactDelteEvent extends ContactResourceDeleteEvent {
  final ContactStoreModel contact;

  const ContactDelteEvent({required this.contact}) : super(object: contact);
}
