import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// FirebaseAnalyticsのインスタンス
final analyticsRepository = Provider((ref) => FirebaseAnalytics.instance);

/// FirebaseAnalyticsObserverのインスタンス
final analyticsObserverRepository = Provider((ref) =>
    FirebaseAnalyticsObserver(analytics: ref.watch(analyticsRepository)));
