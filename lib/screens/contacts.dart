part of contact_app;

class Contacts extends StatefulWidget {
  final bool isFavorite;
  const Contacts({super.key, this.isFavorite = false});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  late final ContactBloc bloc;
  late final ContactBloc globalBloc;
  late final ContactListView _contactList;

  @override
  void initState() {
    bloc = ContactBloc();
    globalBloc = context.read<ContactBloc>();
    _contactList = ContactListView(
      bloc: bloc,
      isFavorite: widget.isFavorite,
      onAction: (contact) {
        showContactDetail(contact);
      },
    );
    _contactList.objects.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocListener<ContactBloc, ContactResourceState>(
          bloc: globalBloc,
          listener: _globalBlocListener,
          child: Column(
            children: [
              _appbar(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 10, 15, 0),
                  child: _contactList,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appbar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: Text(
            "${widget.isFavorite ? 'Fovorite ' : ''}Contacts",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  void _globalBlocListener(BuildContext context, ContactResourceState state) {
    if (state is ContactResourceCreatedState<ContactStoreModel> ||
        state is ContactResourceSyncedState<ContactStoreModel>) {
      _contactList.reset();
    }
  }

  void showContactDetail(ContactStoreModel contact) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ContactDetailNew(
            key: ValueKey(contact.identifier),
            contact: contact,
            onDelete: () {
              deleteContact(contact);
            },
          );
        },
      ),
    );
  }

  void deleteContact(ContactStoreModel contact) {
    bloc.add(ContactDelteEvent(contact: contact));
  }
}
