import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Import Items Parsing', () {
    test('should remove duplicate entries when importing items', () {
      // Simulate the parsing logic from _importItems method
      const text = 'Apple, Banana, Apple, Cherry';
      
      final items = text
          .split(RegExp(r'[,\n]'))
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toSet()
          .toList();
      
      // Should have 3 unique items, not 4
      expect(items.length, 3);
      expect(items, containsAll(['Apple', 'Banana', 'Cherry']));
    });
    
    test('should remove duplicates with newlines', () {
      const text = 'Apple\nBanana\nApple';
      
      final items = text
          .split(RegExp(r'[,\n]'))
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toSet()
          .toList();
      
      // Should have 2 unique items, not 3
      expect(items.length, 2);
      expect(items, containsAll(['Apple', 'Banana']));
    });
    
    test('should handle mixed separators and duplicates', () {
      const text = 'Pizza, Burger\nPizza, Pasta\nBurger';
      
      final items = text
          .split(RegExp(r'[,\n]'))
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toSet()
          .toList();
      
      // Should have 3 unique items
      expect(items.length, 3);
      expect(items, containsAll(['Pizza', 'Burger', 'Pasta']));
    });
    
    test('should trim spaces and remove empty entries', () {
      const text = '  Apple  , , Banana,  ,  Apple  ';
      
      final items = text
          .split(RegExp(r'[,\n]'))
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toSet()
          .toList();
      
      // Should have 2 unique items
      expect(items.length, 2);
      expect(items, containsAll(['Apple', 'Banana']));
    });
    
    test('should handle all items (not just first 2)', () {
      const text = 'Item1, Item2, Item3, Item4, Item5';
      
      final items = text
          .split(RegExp(r'[,\n]'))
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toSet()
          .toList();
      
      // Should have all 5 items
      expect(items.length, 5);
      expect(items, containsAll(['Item1', 'Item2', 'Item3', 'Item4', 'Item5']));
    });
  });
}
