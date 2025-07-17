part of contact_app;

class CreateNewContact extends StatefulWidget {
  final ContactStoreModel? contact;
  const CreateNewContact({super.key, this.contact});

  @override
  State<CreateNewContact> createState() => _CreateNewContactState();
}

class _CreateNewContactState extends State<CreateNewContact> {
  final _formKey = GlobalKey<FormState>();

  final _givenNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _familyNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isFavorite = false;
  late final ContactBloc bloc;

  @override
  void initState() {
    bloc = context.read<ContactBloc>();
    _initPrefilled();
    super.initState();
  }

  @override
  void dispose() {
    _givenNameController.dispose();
    _middleNameController.dispose();
    _familyNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveContact() async {
    showLoadingDialog(context);
    if (_formKey.currentState?.validate() ?? false) {
      final contact = ContactStoreModel(
        givenName: _givenNameController.text.trim(),
        identifier: -1,
        familyName: _familyNameController.text.trim(),
        middleName: _middleNameController.text.trim(),
        phoneNumbers: KVPair(
          key: _phoneController.text.trim(),
          value: 'Mobile',
        ),
        isFavorite: _isFavorite,
        emails:
            _emailController.text.trim().isNotEmpty
                ? KVPair(key: _emailController.text.trim(), value: 'Personal')
                : null,
      );
      // just to show loader if it will be api call then can remove
      await Future.delayed(Duration(milliseconds: 500));

      bloc.add(ContactCreateEvent(contact: contact));
    }
    // close loading
    if (!mounted) return;
    Navigator.pop(context);
  }

  void _updateContact() async {
    showLoadingDialog(context);
    if (_formKey.currentState?.validate() ?? false) {
      final contact = widget.contact!.copyWith(
        givenName: _givenNameController.text.trim(),
        familyName: _familyNameController.text.trim(),
        middleName: _middleNameController.text.trim(),
        phoneNumbers: KVPair(
          key: _phoneController.text.trim(),
          value: 'Mobile',
        ),
        isFavorite: _isFavorite,
        emails:
            _emailController.text.trim().isNotEmpty
                ? KVPair(key: _emailController.text.trim(), value: 'Personal')
                : null,
      );
      // just to show loader if it will be api call then can remove
      await Future.delayed(Duration(milliseconds: 500));

      bloc.add(ContactSyncEvent(contect: contact));
    }
    // close loading
    if (!mounted) return;
    Navigator.pop(context);
  }

  void _initPrefilled() {
    if (widget.contact == null) return;
    _givenNameController.text = widget.contact!.givenName;
    _middleNameController.text = widget.contact!.middleName;
    _familyNameController.text = widget.contact!.familyName;
    _phoneController.text = widget.contact!.phoneNumbers.key;
    _emailController.text =
        widget.contact!.emails != null ? widget.contact!.emails!.key : '';
    _isFavorite = widget.contact!.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Create Contact'),
            backgroundColor: Colors.white,
          ),
          body: BlocListener<ContactBloc, ContactResourceState>(
            bloc: bloc,
            listener: _globalBlocListener,
            child: Column(
              children: [
                Expanded(child: SingleChildScrollView(child: getForm())),
                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: Text(
                    'Save${widget.contact != null ? " changes" : ''}',
                  ),
                  onPressed:
                      widget.contact == null ? _saveContact : _updateContact,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        Form(
          key: _formKey,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ContactFormField(
                  keyboardType: TextInputType.name,

                  title: 'First Name',
                  hint: 'Enter your first name',
                  isRequired: true,
                  textController: _givenNameController,
                ),
                const SizedBox(height: 15),

                ContactFormField(
                  keyboardType: TextInputType.name,

                  title: 'Middle Name',
                  hint: 'Enter your middle name',
                  isRequired: false,
                  textController: _middleNameController,
                ),
                const SizedBox(height: 15),
                ContactFormField(
                  keyboardType: TextInputType.name,

                  title: 'Family Name',
                  hint: 'Enter your last name',
                  isRequired: true,
                  textController: _familyNameController,
                ),
                const SizedBox(height: 15),

                ContactFormField(
                  keyboardType: TextInputType.phone,

                  title: 'Phone Number',
                  hint: 'Enter your Phone Number',
                  isRequired: true,
                  textController: _phoneController,
                ),
                const SizedBox(height: 15),

                ContactFormField(
                  keyboardType: TextInputType.emailAddress,

                  title: 'Email',
                  hint: 'Enter your Email',
                  isRequired: false,
                  textController: _emailController,
                ),
                const SizedBox(height: 15),
                SwitchListTile(
                  title: const Text('Mark as Favorite'),
                  value: _isFavorite,
                  onChanged: (val) => setState(() => _isFavorite = val),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }

  void _globalBlocListener(BuildContext context, ContactResourceState state) {
    if (state is ContactResourceCreatedState<ContactStoreModel> ||
        state is ContactResourceSyncedState<ContactStoreModel>) {
      // close this screen
      Navigator.pop(context);
    }
  }
}
