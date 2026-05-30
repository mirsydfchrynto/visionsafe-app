import 'package:get/get.dart';
import 'package:visionsafe/app/data/services/reward_service.dart';
import 'package:visionsafe/app/data/services/supabase_service.dart';
import 'package:visionsafe/app/data/models/sticker_model.dart';
import 'package:visionsafe/app/data/repositories/profile_repository.dart';
import 'package:visionsafe/app/data/models/profile_model.dart';

/// StatsController: Logika pengelolaan data statistik dan analitik cloud.
class StatsController extends GetxController {
  final _rewardService = Get.find<RewardService>();
  final _supabaseService = Get.find<SupabaseService>();
  final _profileRepo = Get.find<ProfileRepository>();

  final healthScore = 100.obs;
  final weeklyData = <double>[0, 0, 0, 0, 0, 0, 0].obs;
  final screenTimeHours = 0.0.obs;
  final restTimeHours = 0.0.obs;

  final hourlyViolations = List<double>.filled(24, 0.0).obs;
  final stickers = <StickerModel>[].obs;
  final leaderboard = <ProfileModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadStickers();
    fetchCloudAnalytics();
    fetchLeaderboard();
  }

  Future<void> fetchLeaderboard() async {
    try {
      final data = await _profileRepo.getLeaderboard();
      leaderboard.assignAll(data);
    } catch (e) {
      Get.log("Gagal fetch leaderboard: $e");
    }
  }

  void _loadStickers() {
    stickers.value = _rewardService.getAllStickers();
  }

  Future<void> fetchCloudAnalytics() async {
    isLoading.value = true;
    try {
      final data = await _supabaseService.getAnalyticsData(limit: 500);
      if (data.isNotEmpty) {
        _processHeatmapData(data);
      } else {
        _resetToEmptyState();
      }
    } catch (e) {
      _resetToEmptyState();
    } finally {
      isLoading.value = false;
    }
  }

  void _resetToEmptyState() {
    healthScore.value = 100;
    screenTimeHours.value = 0.0;
    restTimeHours.value = 0.0;
    hourlyViolations.value = List.filled(24, 0.0);
  }

  void _processHeatmapData(List<Map<String, dynamic>> logs) {
    if (logs.isEmpty) return;

    final Map<int, List<bool>> hourlyMap = {};
    for (var i = 0; i < 24; i++) {
      hourlyMap[i] = [];
    }

    int totalViolations = 0;
    
    for (var log in logs) {
      try {
        final createdAtStr = log['created_at']?.toString();
        if (createdAtStr == null) continue;
        
        final createdAt = DateTime.parse(createdAtStr);
        final isViolation = log['is_violation'] as bool? ?? false;
        
        if (isViolation) totalViolations++;
        
        final hour = createdAt.hour;
        hourlyMap[hour]?.add(isViolation);
      } catch (e) {
        continue;
      }
    }

    final int logCount = logs.length;
    if (logCount > 0) {
      final double violationRate = totalViolations / logCount;
      final double rawScore = 100 - (violationRate * 100);
      healthScore.value = rawScore.isNaN || rawScore.isInfinite 
          ? 100 
          : rawScore.clamp(0, 100).toInt();
      
      final double rawScreenTime = (logCount * 5) / 3600;
      screenTimeHours.value = rawScreenTime.isNaN || rawScreenTime.isInfinite ? 0.0 : rawScreenTime;
      restTimeHours.value = screenTimeHours.value * 0.2;
    }

    final List<double> newIntensity = List.filled(24, 0.0);
    for (var i = 0; i < 24; i++) {
      final logList = hourlyMap[i]!;
      if (logList.isNotEmpty) {
        final double rawIntensity = logList.where((v) => v).length / logList.length;
        newIntensity[i] = rawIntensity.isNaN || rawIntensity.isInfinite ? 0.0 : rawIntensity;
      }
    }
    
    hourlyViolations.value = newIntensity;
  }
}
