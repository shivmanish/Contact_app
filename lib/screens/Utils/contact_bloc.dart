part of contact_app;

class ContactBloc extends ContactResourceBloc<ContactStoreModel> {
  ContactBloc();

  @override
  Future<ContactListApiResponse<ContactStoreModel>?> list(
    ContactResourceListEvent event,
  ) async {
    final contactListEvent = event as ContactListEvent;
    final listResponse =
        contactListEvent.isFavorite
            ? await ContactDb.instance.getFavoriteContacts()
            : await ContactDb.instance.getAllContacts();
    return ContactListApiResponse<ContactStoreModel>(
      results: listResponse,
      count: listResponse.length,
    );
  }

  @override
  Future<ContactStoreModel?> fetch(ContactResourceFetchEvent event) async {
    try {
      final fetchResponse = await ContactDb.instance.getContactById(
        event.id.toString(),
      );
      return fetchResponse;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ContactStoreModel?> create(ContactResourceCreateEvent event) async {
    try {
      final createEvent = event as ContactCreateEvent;
      int id = await ContactDb.instance.insertContact(createEvent.contact);
      createEvent.contact.updateIdentifier(id);
      return createEvent.contact;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> delete(ContactResourceDeleteEvent event) async {
    final deleteEvent = event as ContactDelteEvent;

    ContactDb.instance.deleteContact(deleteEvent.contact.identifier.toString());
  }

  @override
  Future<ContactStoreModel?> sync(ContactResourceSyncEvent event) async {
    final syncEvent = event as ContactSyncEvent;
    if (syncEvent.isFavorite != null) {
      await ContactDb.instance.toggleFavorite(
        syncEvent.contect.identifier.toString(),
        syncEvent.isFavorite!,
      );
      syncEvent.contect.updateFavourite(syncEvent.isFavorite!);
      return syncEvent.contect;
    }
    await ContactDb.instance.updateContact(syncEvent.contect);
    return syncEvent.contect;
  }
}
