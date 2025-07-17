part of contact_app;

class ContactFormField extends StatelessWidget {
  final String title;
  final bool isRequired;
  final String? hint;
  final TextEditingController textController;
  final void Function(String text)? onTextChange;
  final List<String> Function()? serverErrorsCallback;
  final bool isEditable;
  final TextInputType keyboardType;
  final int? maxInputLength;
  final String? Function(String)? textValidator;
  final bool focusIfEmpty;

  const ContactFormField({
    super.key,
    this.isRequired = true,
    this.hint,
    this.onTextChange,
    this.serverErrorsCallback,
    required this.title,
    required this.textController,
    this.isEditable = true,
    this.keyboardType = TextInputType.text,
    this.maxInputLength,
    this.textValidator,
    this.focusIfEmpty = false,
  });

  String? errorText(String? value) {
    if (isRequired) {
      if (value!.trim().isEmpty) {
        return "Required Field can't be empty";
      } else {
        if (textValidator != null) {
          return textValidator!(value);
        }
      }
    }
    if (serverErrorsCallback != null && serverErrorsCallback!().isNotEmpty) {
      return serverErrorsCallback!().join("\n");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).hintColor,
                  letterSpacing: -0.31,
                ),
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 5),
              const Icon(
                Icons.star_rate_rounded,
                color: Color.fromARGB(255, 184, 64, 56),
                size: 10,
              ),
            ],
          ],
        ),
        const SizedBox(height: 6),
        FormTextField(
          focusIfEmpty: focusIfEmpty,
          keyBoardType: keyboardType,
          isEditable: isEditable,
          onChange: (text) {
            if (onTextChange != null) onTextChange!(text.trim());
          },
          textEditingController: textController,
          hintText: hint ?? '',
          textValidator: errorText,
          maxLength: maxInputLength,
        ),
      ],
    );
  }
}
