part of contact_app;

/// An abstract list view class for object O.
///
/// To use this class, extend it and implement the necessary abstract methods
/// to take control of build lifecycle.
abstract class ContactResourceListView<O> extends StatefulWidget {
  // Initial state of the list view
  final int startingPage;
  final int pageSize;
  final ContactResourceBloc<O> bloc;

  ContactResourceListView({
    super.key,
    required this.bloc,
    this.startingPage = 0,
    this.pageSize = 100,
  });

  // Abstract method
  ContactResourceListEvent getResourceListEvent({
    required int limit,
    required int offset,
  });
  Widget listingErrorWidget(ContactResourceState state);
  Widget noItemFoundBuilder(BuildContext context);
  Widget listItemBuilder(O object, BuildContext context, int index);
  void onListingError(ContactResourceState state);

  // Implemented methods (override iff necessary)
  Widget initialStateWidget(ContactResourceState state) {
    return loadingWidget();
  }

  Widget listingStateWidget(ContactResourceState state) {
    return loadingWidget();
  }

  Widget? creatingStateWidget(ContactResourceState state) {
    return loadingWidget();
  }

  Widget? deletingStateWidget(ContactResourceState state) {
    return loadingWidget();
  }

  Widget? syncingStateWidget(ContactResourceState state) {
    return loadingWidget();
  }

  Widget cursorListingStateWidget(ContactResourceState state) {
    return loadingWidget();
  }

  /// This function will help to manage error state of any event
  /// it will prevent that on any point on 'pagination' or
  /// other event if any error happened then can make decision
  /// should show error state with clear all data or not
  /// based upon [ContactResourceState]
  ///
  bool shouldShowErrorState(ContactResourceErrorState state) {
    return true;
  }

  // E.g. use objects to access any object by index.
  final List<O> objects = [];

  @override
  State<ContactResourceListView<O>> createState() =>
      ContactResourceListViewState<O>();

  Widget loadingWidget() {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(color: Colors.deepPurpleAccent),
      ],
    );
  }

  /// Reset list view e.g. when UI filters are changed.
  void reset() {
    // Clear objects
    objects.clear();
    // Request starting page again
    bloc.add(
      getResourceListEvent(limit: pageSize, offset: startingPage * pageSize),
    );
  }

  void syncedStateWidget(ContactResourceSyncedState<O> state) {
    objects.insert(0, state.resource);
  }
}

class ContactResourceListViewState<O>
    extends State<ContactResourceListView<O>> {
  bool needsPagination = false;
  bool cursorListing = false;
  ContactResourceState? currentState;
  ContactResourceState? executedState;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              widget.bloc..add(
                widget.getResourceListEvent(
                  limit: widget.pageSize,
                  offset: widget.startingPage * widget.pageSize,
                ),
              ),
      child: BlocListener<ContactResourceBloc<O>, ContactResourceState>(
        listener: (context, state) {
          if (state is ContactResourceErrorState) {
            widget.onListingError(state);
          }
        },
        child: BlocBuilder<ContactResourceBloc<O>, ContactResourceState>(
          builder: blocStateBuilder,
          buildWhen: (previous, current) {
            currentState = current;
            return previous != current;
          },
        ),
      ),
    );
  }

  Widget blocStateBuilder(context, state) {
    if (state is ContactResourceInitialState) {
      return widget.initialStateWidget(state);
    } else if (state is ContactResourceListingState) {
      return widget.listingStateWidget(state);
    } else if (state is ContactResourceErrorState &&
        widget.shouldShowErrorState(state)) {
      return widget.listingErrorWidget(state);
    } else if (state is ContactResourceListedState<O> &&
        isCurrentStateAndExecutedStateDiff()) {
      // Store objects locally
      widget.objects.addAll(state.response.results);
      needsPagination = state.response.count! > widget.objects.length;
    } else if (state is ContactResourceCreatedState<O>) {
      widget.objects.insert(0, state.resource);
    } else if (state is ContactResourceDeletingState) {
      // if (widget.deletingStateWidget(state) != null) {
      //   return widget.deletingStateWidget(state)!;
      // }
    } else if (state is ContactResourceDeletedState<O>) {
      final deletedEvent = state.event as ContactResourceDeleteEvent;
      widget.objects.removeWhere((element) => element == deletedEvent.object);
    } else if (state is ContactResourceSyncedState<O>) {
      widget.syncedStateWidget(state);
    }
    executedState = currentState;
    int itemCountTemp =
        needsPagination ? widget.objects.length + 1 : widget.objects.length;
    itemCountTemp = cursorListing ? itemCountTemp + 1 : itemCountTemp;
    final itemCount = itemCountTemp != 0 ? itemCountTemp : 1;

    return handleListType(itemCount, itemCountTemp);
  }

  Widget handleListType(int itemCount, int itemCountTemp) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder:
          (context, index) => itemBuilder(itemCountTemp, context, index),
    );
  }

  Widget itemBuilder(int objectLength, BuildContext context, int index) {
    // No object found
    if (objectLength == 0) {
      return widget.noItemFoundBuilder(context);
    }
    int tempIndex = index;

    // We have a local copy of object, build item immediately
    if (tempIndex < widget.objects.length) {
      return widget.listItemBuilder(
        widget.objects[tempIndex],
        context,
        tempIndex,
      );
    }

    // We need to fetch more pages to build further tiles.
    //
    // NOTE: We may end up adding multiple events here
    // because ListView builder will keep calling us
    // for indexes it wants to render.
    //
    // But only first event will be processed by resource
    // bloc class which internally will debounce resource event
    // based upon their equatable properties.
    if (tempIndex == widget.objects.length) {
      widget.bloc.add(
        widget.getResourceListEvent(
          limit: widget.pageSize,
          offset: widget.objects.length,
        ),
      );
    }

    return widget.loadingWidget();
  }

  /// below function is check that last build state and current state is same or not
  /// if both are same then do not add items in objects
  ///
  /// objects is empty state is for handling reset function
  /// when reset will be called then executed and current state can be same
  /// so it that case when reset will be called all objects will be cleared
  bool isCurrentStateAndExecutedStateDiff() {
    return (currentState != null &&
            executedState != null &&
            currentState != executedState) ||
        executedState == null ||
        widget.objects.isEmpty;
  }
}
