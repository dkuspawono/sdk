// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analysis_server/src/services/correction/assist.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import 'assist_processor.dart';

main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(SortChildPropertyLastTest);
  });
}

@reflectiveTest
class SortChildPropertyLastTest extends AssistProcessorTest {
  @override
  AssistKind get kind => DartAssistKind.SORT_CHILD_PROPERTY_LAST;

  test_already_sorted() async {
    addFlutterPackage();
    await resolveTestUnit('''
import 'package:flutter/material.dart';
main() {
  Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Text('aaa'),
      Text('bbbbbb'),
      Text('ccccccccc'),
    ],
  );
}
''');
    await assertNoAssist();
  }

  test_already_sorted_one_prop() async {
    addFlutterPackage();
    await resolveTestUnit('''
import 'package:flutter/material.dart';
main() {
  Column(
    children: <Widget>[
      Text('aaa'),
      Text('bbbbbb'),
      Text('ccccccccc'),
    ],
  );
}
''');
    await assertNoAssist();
  }

  test_no_children() async {
    addFlutterPackage();
    await resolveTestUnit('''
import 'package:flutter/material.dart';
main() {
  Column(
    crossAxisAlignment: CrossAxisAlignment.center,
  );
}
''');
    await assertNoAssist();
  }

  test_sort() async {
    addFlutterPackage();
    await resolveTestUnit('''
import 'package:flutter/material.dart';
main() {
  Column(
    /*caret*/children: <Widget>[
      Text('aaa'),
      Text('bbbbbb'),
      Text('ccccccccc'),
    ],
    crossAxisAlignment: CrossAxisAlignment.center,
  );
}
''');
    await assertHasAssist('''
import 'package:flutter/material.dart';
main() {
  Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Text('aaa'),
      Text('bbbbbb'),
      Text('ccccccccc'),
    ],
  );
}
''');
    assertExitPosition(after: "],");
  }
}
