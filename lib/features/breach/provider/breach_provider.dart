import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/breach_result.dart';
import '../../../data/repositories/breach_repository.dart';
import '../../../shared/providers/app_provider.dart';

class BreachState {
  final bool isLoading;
  final BreachResult? result;
  final String? error;
  final String statusMessage;

  BreachState({
    required this.isLoading,
    this.result,
    this.error,
    this.statusMessage = '',
  });

  BreachState copyWith({
    bool? isLoading,
    BreachResult? result,
    String? error,
    String? statusMessage,
  }) {
    return BreachState(
      isLoading: isLoading ?? this.isLoading,
      result: result ?? this.result,
      error: error,
      statusMessage: statusMessage ?? this.statusMessage,
    );
  }
}

class BreachNotifier extends StateNotifier<BreachState> {
  BreachNotifier(this._repository) : super(BreachState(isLoading: false));

  final BreachRepository _repository;

  Future<void> check(String input) async {
    if (input.trim().isEmpty) {
      state = state.copyWith(error: 'Please enter an email or phone number.');
      return;
    }
    state = state.copyWith(isLoading: true, error: null, statusMessage: 'Hashing credential...');
    await Future.delayed(const Duration(milliseconds: 400));
    state = state.copyWith(statusMessage: 'Checking breach database...');
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final result = await _repository.check(input);
      state = BreachState(isLoading: false, result: result, statusMessage: '');
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        error: 'Unable to reach breach service. Check your connection.',
        statusMessage: '',
      );
    }
  }
}

final breachCheckProvider = StateNotifierProvider<BreachNotifier, BreachState>(
  (ref) => BreachNotifier(ref.read(breachRepositoryProvider)),
);
