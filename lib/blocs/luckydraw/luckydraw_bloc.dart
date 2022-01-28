import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:qb_admin/models/luckydraw.dart';
import 'package:qb_admin/repositories/luckydraw/luckydraw_repository.dart';
part 'luckydraw_event.dart';
part 'luckydraw_state.dart';

// ignore: camel_case_types
class LuckyDrawBloc extends Bloc<LuckyDrawEvent, LuckyDrawState> {
  final LuckyDrawRepository _LuckyDrawRepository;
  StreamSubscription? _LuckyDrawSubscription;
  LuckyDrawBloc({required LuckyDrawRepository LuckyDrawRepository})
      : _LuckyDrawRepository = LuckyDrawRepository,
        super(LuckyDrawLoading());
  @override
  Stream<LuckyDrawState> mapEventToState(
    LuckyDrawEvent event,
  ) async* {
    if (event is LoadLuckyDraw) {
      yield* _mapLoadLuckyDrawsToState();
    }
    if (event is UpdateLuckyDraw) {
      yield* _mapUpdateLuckyDrawsToState(event);
    }
  }

  Stream<LuckyDrawState> _mapLoadLuckyDrawsToState() async* {
    _LuckyDrawSubscription?.cancel();
    _LuckyDrawSubscription = _LuckyDrawRepository.getAllLuckyDraw().listen(
      (LuckyDraws) => add(
        UpdateLuckyDraw(LuckyDraws),
      ),
    );
  }

  Stream<LuckyDrawState> _mapUpdateLuckyDrawsToState(
      UpdateLuckyDraw event) async* {
    yield LuckyDrawLoaded(draw: event.draws);
  }
}
