import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaana/example.dart';
import 'package:gaana/gaana.dart';

void main() {
  test("tests Gaana", () {
    final gaana = Gaana(child: SizedBox());
    gaana.notifier?.add(UsersNotifier(exampleUsers));
    final un = gaana.notifier?.get<UsersNotifier>();
    expect(un?.users.length, greaterThan(1));
  });
}
