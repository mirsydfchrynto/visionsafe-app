import 'dart:math';

class UuidGenerator {
  static final Random _random = Random.secure();

  /// Generates a RFC 4122 version 4 UUID.
  static String generateV4() {
    final int r1 = _random.nextInt(0xffffffff);
    final int r2 = _random.nextInt(0xffffffff);
    final int r3 = _random.nextInt(0xffffffff);
    final int r4 = _random.nextInt(0xffffffff);

    // Format as 8-4-4-4-12 hex string
    final String s1 = r1.toRadixString(16).padLeft(8, '0');
    final String s2 = (r2 & 0xffff).toRadixString(16).padLeft(4, '0');
    // Set version to 4 (0100 binary in high bits)
    final String s3 = (((r2 >> 16) & 0x0fff) | 0x4000).toRadixString(16).padLeft(4, '0');
    // Set variant to RFC 4122 (10xx binary in high bits)
    final String s4 = (((r3 & 0x3fff) | 0x8000)).toRadixString(16).padLeft(4, '0');
    final String s5 = ((r3 >> 16) | (r4 << 16)).toRadixString(16).padLeft(12, '0');

    return '$s1-$s2-$s3-$s4-$s5';
  }
}
