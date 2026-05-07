
class DashboardState{
  final int index;

  DashboardState({
     this.index= 0,

      });

  DashboardState copyWith({
    int? index,
  }) {
    return DashboardState(
      index: index ?? this.index,
    );
  }

}