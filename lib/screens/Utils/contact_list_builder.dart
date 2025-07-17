part of contact_app;

class ContactListView extends ContactResourceListView<ContactStoreModel> {
  final bool isFavorite;
  final void Function(ContactStoreModel) onAction;
  ContactListView({
    super.key,
    required super.bloc,
    super.startingPage,

    this.isFavorite = false,
    required this.onAction,
  });

  @override
  ContactResourceListEvent getResourceListEvent({
    required int limit,
    required int offset,
  }) {
    return ContactListEvent(
      limit: limit,
      offset: offset,
      isFavorite: isFavorite,
    );
  }

  @override
  void syncedStateWidget(ContactResourceSyncedState<ContactStoreModel> state) {
    final event = state.event as ContactSyncEvent;
    int index = objects.indexWhere(
      (element) => element.identifier == event.contect.identifier,
    );
    if (index >= 0 && index < objects.length) {
      objects[index] = state.resource;
    }
  }

  @override
  Widget noItemFoundBuilder(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.8,
      width: MediaQuery.sizeOf(context).width,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.contact_page, size: 30),
            const SizedBox(height: 30),
            const Text("No Contact Available", style: TextStyle(fontSize: 22)),
            const SizedBox(height: 10),
            Text(
              "No contact available, With add button create new contact",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).hintColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  @override
  Widget listItemBuilder(
    ContactStoreModel object,
    BuildContext context,
    int index,
  ) {
    return ContactItem(
      key: ValueKey(object.identifier),
      contact: object,
      onShowContactDetail: () {
        onAction(object);
      },
      onCallContact: () {},
      characterWillChange: objects.length - 1 == index,
      showCharacter: index == 0,
    );
  }

  @override
  Widget loadingWidget() {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 24),
        Center(child: CircularProgressIndicator()),
      ],
    );
  }

  @override
  Widget listingErrorWidget(ContactResourceState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: const Text(
            'Oops! Something went a bit sideways. Please try again',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF8E8E93),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  @override
  void onListingError(ContactResourceState state) {
    final errorState = state as ContactResourceErrorState;
    print(
      '============= ${errorState.message} \n Something went wrong. \n try again later',
    );

    // here can show Toast message
  }
}
