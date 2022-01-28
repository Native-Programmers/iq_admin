part of 'luckydraw_bloc.dart';

abstract class LuckyDrawState extends Equatable {
  const LuckyDrawState();

  @override
  List<Object> get props => [];
}

class LuckyDrawLoading extends LuckyDrawState {}

class LuckyDrawLoaded extends LuckyDrawState {
  final List<LuckyDraw> draw;

  const LuckyDrawLoaded({this.draw = const <LuckyDraw>[]});

  @override
  List<Object> get props => [draw];
}

class LuckyDrawError extends LuckyDrawState {}
