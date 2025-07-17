part of contact_app;

class FormTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final String? Function(String?)? textValidator;
  final void Function(String)? onChange;
  final bool isEditable;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType keyBoardType;
  final int? maxLength;
  final Color? textColor;
  final bool focusIfEmpty;
  final bool readOnly;
  final bool showCursor;

  const FormTextField({
    super.key,
    required this.textEditingController,
    required this.hintText,
    this.textValidator,
    this.onChange,
    this.isEditable = true,
    required this.keyBoardType,
    this.inputFormatters,
    this.maxLength,
    this.focusIfEmpty = false,
    this.textColor,
    this.readOnly = false,
    this.showCursor = true,
  });

  @override
  State<FormTextField> createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    if (widget.focusIfEmpty && widget.textEditingController.text.isEmpty) {
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: _focusNode,
      textInputAction: TextInputAction.next,
      keyboardType: widget.keyBoardType,
      readOnly: widget.readOnly,
      showCursor: widget.showCursor,
      enabled: widget.isEditable,
      textCapitalization:
          widget.keyBoardType == TextInputType.name
              ? TextCapitalization.words
              : TextCapitalization.none,
      controller: widget.textEditingController,
      style: TextStyle(
        color:
            widget.textColor ??
            (widget.isEditable
                ? Theme.of(context).primaryColor
                : Theme.of(context).hintColor),
        letterSpacing: 1,
      ),
      onChanged: widget.onChange,
      validator: widget.textValidator,
      inputFormatters: widget.inputFormatters,
      decoration: InputDecoration(
        errorMaxLines: 10,
        filled: true,
        fillColor: Theme.of(context).secondaryHeaderColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(26),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18.25,
          vertical: 14,
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Theme.of(context).hintColor,
          fontWeight: FontWeight.w400,
          fontSize: min(16, MediaQuery.of(context).size.width / 23),
        ),
      ),
      maxLength: widget.maxLength,
    );
  }
}
