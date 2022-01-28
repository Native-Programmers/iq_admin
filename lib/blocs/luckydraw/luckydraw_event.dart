part of 'luckydraw_bloc.dart';

abstract class LuckyDrawEvent extends Equatable {
  const LuckyDrawEvent();

  @override
  List<Object> get props => [];
}

class LoadLuckyDraw extends LuckyDrawEvent {}

class UpdateLuckyDraw extends LuckyDrawEvent {
  final List<LuckyDraw> draws;
  const UpdateLuckyDraw(this.draws);

  @override
  List<Object> get props => [draws];
}
