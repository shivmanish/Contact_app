part of contact_app;

class ContactItem extends StatefulWidget {
  final ContactStoreModel contact;
  final VoidCallback onShowContactDetail;
  final VoidCallback onCallContact;
  final bool showCharacter;
  final bool characterWillChange;

  const ContactItem({
    super.key,
    required this.contact,
    required this.onShowContactDetail,
    required this.onCallContact,
    this.showCharacter = false,
    this.characterWillChange = false,
  });

  @override
  State<ContactItem> createState() => _ContactItemState();
}

class _ContactItemState extends State<ContactItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: _contactTile(widget.contact));
  }

  /// Returns [ListTile].
  Widget _contactTile(ContactStoreModel contact) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.showCharacter ? const SizedBox(height: 14) : Container(),

        widget.showCharacter ? const SizedBox(height: 14) : Container(),
        GestureDetector(
          onTap: widget.onShowContactDetail,
          child: Container(
            height: 65,
            decoration: BoxDecoration(
              color: Theme.of(context).secondaryHeaderColor,
              borderRadius: BorderRadius.only(
                topLeft:
                    widget.showCharacter
                        ? const Radius.circular(12.0)
                        : Radius.zero,
                topRight:
                    widget.showCharacter
                        ? const Radius.circular(12.0)
                        : Radius.zero,
                bottomLeft:
                    widget.characterWillChange
                        ? const Radius.circular(12.0)
                        : Radius.zero,
                bottomRight:
                    widget.characterWillChange
                        ? const Radius.circular(12.0)
                        : Radius.zero,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 17),
              child: Row(
                children: [
                  widget.contact.circleAvatar(
                    radius: 16,
                    backgroundColor: Theme.of(context).indicatorColor,
                    textStyle: TextStyle(
                      fontSize: 12.0,
                      color: Theme.of(context).hintColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width) * (0.45),
                    child: Text(
                      contact.getDisplayableName(),
                      key: const Key('on_click_contact_name'),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Spacer(),
                  _trailingItem(),
                ],
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 18),
          child: Divider(
            height: 1,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
        widget.characterWillChange ? const SizedBox(height: 14) : Container(),
      ],
    );
  }

  /// Returns trailing action items for list tile.
  Widget _trailingItem() {
    return IconButton(
      onPressed: widget.onCallContact,
      icon: Icon(Icons.phone_rounded),
    );
  }
}
