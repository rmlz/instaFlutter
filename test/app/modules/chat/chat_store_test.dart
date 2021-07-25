import 'package:flutter_test/flutter_test.dart';
import 'package:instamon/app/modules/chat/chat_store.dart';

void main() {
  late ChatStore store;

  setUpAll(() {
    store = ChatStore();
  });

  test('increment count', () async {
    expect(store.value, equals(0));
    store.increment();
    expect(store.value, equals(1));
  });
}
