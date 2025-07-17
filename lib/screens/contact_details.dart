part of contact_app;

enum ContactActions { favorite, edit, delete }

class JaxlContactDetailNew extends StatefulWidget {
  final ContactStoreModel contact;
  final void Function() onDelete;

  const JaxlContactDetailNew({
    super.key,
    required this.contact,
    required this.onDelete,
  });

  @override
  _JaxlContactDetailStateNew createState() => _JaxlContactDetailStateNew();
}

class _JaxlContactDetailStateNew extends State<JaxlContactDetailNew> {
  bool appBarToShow = false;
  late ContactStoreModel _contact;
  late final ContactBloc bloc;

  int activeIndex = 0;

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    _contact = widget.contact;
    bloc = context.read<ContactBloc>();
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int contactNameLength = _contact.getDisplayableName().length;
    int nameMaxLines = (contactNameLength / 22).ceil();
    int contactNameHeight = nameMaxLines * 33;
    // header height + contact name height + blocked tile height + recording tile height
    double expandedHeight = 215.0 + contactNameHeight + 100;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocListener<ContactBloc, ContactResourceState>(
          bloc: bloc,
          listener: updateContactModal,
          child: BlocBuilder<ContactBloc, ContactResourceState>(
            builder: (context, state) {
              return Stack(
                children: [
                  ListView(
                    controller: _controller,
                    children: [
                      const SizedBox(height: 50),
                      ..._childrens(nameMaxLines, expandedHeight),
                    ],
                  ),
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 500),
                    crossFadeState:
                        appBarToShow
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                    firstChild: SizedBox(
                      height: 80,
                      child: CollapsedHeader(
                        contact: _contact,
                        nameMaxLines: nameMaxLines,
                        expandedHeight: expandedHeight,

                        onUpdateOptionsCallback: _onUpdateOptions,
                      ),
                    ),

                    secondChild: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            Colors.white.withValues(alpha: 1),
                            Colors.white.withValues(alpha: .8),
                            Colors.white.withValues(alpha: 0),
                          ],
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                            ),
                            child: SizedBox(
                              width: 15,
                              height: 24,
                              child: Icon(
                                const IconData(
                                  0xe093,
                                  fontFamily: 'MaterialIcons',
                                  matchTextDirection: true,
                                ),
                                key: const Key('contact_details_back_action'),
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  !appBarToShow
                      ? Positioned(
                        top: 50,
                        child: ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                            child: Container(
                              height: 70,
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      )
                      : Container(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _childrens(int nameMaxLines, double expandedHeight) {
    List<Widget> children = [];

    children.add(
      ExpandedAppbar(
        contact: _contact,
        nameMaxLines: nameMaxLines,
        expandedHeight: expandedHeight,

        onUpdateOptionsCallback: _onUpdateOptions,
      ),
    );
    children.add(const SizedBox(height: 25));

    children.add(
      // _container(
      PhoneNumberContainer(
        contact: _contact,
        phoneNumbers: _contact.phoneNumbers,
      ),
      // ),
    );
    return children;
  }

  void updateContactModal(BuildContext context, ContactResourceState state) {
    if (state is ContactResourceSyncedState<ContactStoreModel>) {
      _contact = state.resource;
    }
  }

  _scrollListener() {
    if (_controller.offset >= 190) {
      if (appBarToShow != true) {
        appBarToShow = true;

        setState(() {});
      }
    }
    if (_controller.offset < 190) {
      if (appBarToShow != false) {
        appBarToShow = false;

        setState(() {});
      }
    }
  }

  late ScrollController _controller;

  void _onUpdateOptions(ContactActions action) {
    if (action == ContactActions.favorite) {
      bloc.add(
        ContactSyncEvent(contect: _contact, isFavorite: !_contact.isFavorite),
      );
    } else if (action == ContactActions.edit) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => CreateNewContact(
                key: ValueKey(_contact.identifier),
                contact: _contact,
              ),
        ),
      );
    } else if (action == ContactActions.delete) {
      widget.onDelete();
      Navigator.pop(context);
    }
  }

  void callUpdateMethod(ContactStoreModel existingContact) {}
}

class PhoneNumberContainer extends StatefulWidget {
  final ContactStoreModel contact;
  final KVPair phoneNumbers;

  final int minItemsToRender;

  const PhoneNumberContainer({
    super.key,
    required this.phoneNumbers,
    required this.contact,
    this.minItemsToRender = 1,
  });

  @override
  State<PhoneNumberContainer> createState() => _PhoneNumberContainerState();
}

class _PhoneNumberContainerState extends State<PhoneNumberContainer> {
  Widget _numberTile() {
    final phone = widget.phoneNumbers;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      phone.value!,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 6),
              SizedBox(
                child: Text(
                  phone.key,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 17,
                    color: Theme.of(context).hintColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        ...phoneCallIconWidgets(phone),
      ],
    );
  }

  List<Widget> phoneCallIconWidgets(KVPair phone) {
    return [
      const SizedBox(width: 20),
      IconButton(onPressed: () {}, icon: Icon(Icons.phone_rounded)),
    ];
  }

  // Returns numberes container
  Widget _numbersContainer() {
    List<Widget> children = [_numberTile()];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  Widget _container(Widget child) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).secondaryHeaderColor,
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: child,
    );
  }

  Widget _emailContainer() {
    List<Widget> children = [_emailTile()];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  // Returns message icon for email section
  Widget _emailIcon({
    VoidCallback? onTap,
    double radius = 25,
    double size = 20,
  }) {
    return InkWell(
      onTap: onTap,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey,
        child: Icon(
          const IconData(0xe22a, fontFamily: 'MaterialIcons'),
          color: Theme.of(context).primaryColor,
          size: size,
        ),
      ),
    );
  }

  // Returns email tile
  Widget _emailTile() {
    final email = widget.contact.emails!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                email.value!,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                email.key,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 17,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ],
          ),
        ),
        _emailIcon(onTap: () async {}),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (widget.contact.hasEmailId()) {
      children.add(_container(_emailContainer()));
    }

    children.insert(0, _container(_numbersContainer()));
    return Column(children: children);
  }
}

class ExpandedAppbar extends StatefulWidget {
  final double expandedHeight;
  final ContactStoreModel contact;
  final int nameMaxLines;
  final void Function(ContactActions) onUpdateOptionsCallback;

  const ExpandedAppbar({
    super.key,
    required this.contact,
    required this.nameMaxLines,
    required this.expandedHeight,
    required this.onUpdateOptionsCallback,
  });

  @override
  State<ExpandedAppbar> createState() => _ExpandedAppbarState();
}

class _ExpandedAppbarState extends State<ExpandedAppbar> {
  Widget _iconRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            widget.onUpdateOptionsCallback(ContactActions.favorite);
          },
          icon: Icon(
            const IconData(0xf01d4, fontFamily: 'MaterialIcons'),
            color:
                widget.contact.isFavorite
                    ? const Color(0xFFF19D38)
                    : Colors.grey,
            size: 38,
          ),
        ),
        const SizedBox(width: 18),

        IconButton(
          onPressed: () {
            widget.onUpdateOptionsCallback(ContactActions.edit);
          },
          icon: Icon(Icons.mode_edit_outlined, color: Colors.grey, size: 38),
        ),
        const SizedBox(width: 18),
        IconButton(
          onPressed: () {
            widget.onUpdateOptionsCallback(ContactActions.delete);
          },
          icon: Icon(
            Icons.delete_outline_rounded,
            color: Colors.grey,
            size: 38,
          ),
        ),
      ],
    );
  }

  Widget thumbnailWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: widget.contact.circleAvatar(radius: 53, statusCircleRadius: 24),
    );
  }

  Widget _expandedHeader(BuildContext context) {
    List<Widget> children = [
      Container(),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [thumbnailWidget()],
      ),
      Container(
        width: 350,
        padding: const EdgeInsets.fromLTRB(16, 5, 16, 0),
        child: Text(
          widget.contact.getDisplayableName(),
          textAlign: TextAlign.center,
          maxLines: widget.nameMaxLines,
          style: TextStyle(
            overflow: TextOverflow.ellipsis,
            fontSize: 28,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.36,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      _iconRow(),
    ];

    return Column(mainAxisSize: MainAxisSize.min, children: children);
  }

  @override
  Widget build(BuildContext context) {
    return _expandedHeader(context);
  }
}

class CollapsedHeader extends StatelessWidget {
  final double expandedHeight;
  final ContactStoreModel contact;
  final int nameMaxLines;
  final void Function(ContactActions) onUpdateOptionsCallback;

  const CollapsedHeader({
    super.key,
    required this.contact,
    required this.nameMaxLines,
    required this.expandedHeight,
    required this.onUpdateOptionsCallback,
  });

  Widget _collapsedHeader(BuildContext context) {
    List<Widget> children = [
      SizedBox(
        width: 130,
        child: Text(
          contact.getDisplayableName(),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            letterSpacing: .36,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    ];

    return Container(
      alignment: Alignment.center,
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.only(top: 12, bottom: 11, left: 16, right: 32),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: SizedBox(
              width: 15,
              height: 24,
              child: Icon(
                const IconData(
                  0xe093,
                  fontFamily: 'MaterialIcons',
                  matchTextDirection: true,
                ),
                color: Theme.of(context).hintColor,
              ),
            ),
          ),
          const SizedBox(width: 14),
          contact.circleAvatar(radius: 24.5),
          const SizedBox(width: 9),
          Expanded(child: Row(children: children)),
          const SizedBox(width: 2),
          IconButton(onPressed: () {}, icon: Icon(Icons.phone_rounded)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _collapsedHeader(context);
  }
}
