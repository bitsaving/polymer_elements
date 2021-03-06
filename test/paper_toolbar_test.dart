// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
@TestOn('browser')
library polymer_elements.test.paper_toolbar_test;

import 'dart:async';
import 'dart:html';
import 'package:polymer_elements/paper_toolbar.dart';
import 'package:polymer_interop/polymer_interop.dart';
import 'package:web_components/web_components.dart';
import 'package:test/test.dart';
import 'common.dart';

/**
 * Original tests:
 * https://github.com/PolymerElements/paper-toolbar/tree/master/test
 */

main() async {
  await initWebComponents();

  group('basic', () {
    PaperToolbar toolbar;

    setUp(() async {
      toolbar = fixture('basic');
      await new Future(() {});
    });

    test('has expected medium-tall height', () {
      int old = toolbar.offsetHeight;
      toolbar.classes.add('medium-tall');
      expect(toolbar.offsetHeight, equals(old * 2));
    });

    test('has expected tall height', () {
      int old = toolbar.offsetHeight;
      toolbar.classes.add('tall');
      expect(toolbar.offsetHeight, equals(old * 3));
    });

    test('distributes nodes to topBar by default', () {
      DivElement item = new DivElement();
      Polymer.dom(toolbar).append(item);
      PolymerDom.flush();

      HtmlElement insertionPoint =
          Polymer.dom(item).getDestinationInsertionPoints()[0];
      expect(
          Polymer.dom(insertionPoint).parentNode, equals(toolbar.$['topBar']));
    });

    test('distributes nodes with "middle" class to middleBar', () {
      DivElement item = new DivElement();
      item.classes.add('middle');
      Polymer.dom(toolbar).append(item);
      PolymerDom.flush();

      HtmlElement insertionPoint =
          Polymer.dom(item).getDestinationInsertionPoints()[0];
      expect(Polymer.dom(insertionPoint).parentNode,
          equals(toolbar.$['middleBar']));
    });

    test('distributes nodes with "bottom" class to bottombar', () {
      DivElement item = new DivElement();
      item.classes.add('bottom');
      Polymer.dom(toolbar).append(item);
      PolymerDom.flush();

      HtmlElement insertionPoint =
          Polymer.dom(item).getDestinationInsertionPoints()[0];
      expect(Polymer.dom(insertionPoint).parentNode,
          equals(toolbar.$['bottomBar']));
    });
  });

  group('a11y', () {
    test('has role="toolbar"', () async {
      PaperToolbar toolbar = fixture('basic');
      await new Future(() {});
      expect(toolbar.getAttribute('role'), equals('toolbar'),
          reason: 'should have role="toolbar"');
    });

    test('children with .title becomes the label', () async {
      PaperToolbar toolbar = fixture('title');
      await new Future(() {});
      expect(toolbar.getAttribute('aria-labelledby'), isNotNull,
          reason: 'should have aria-labelledby');
      expect(toolbar.getAttribute('aria-labelledby'),
          equals(toolbar.querySelector('.title').id),
          reason: 'aria-labelledby should have the id of the .title element');
    });

    test('existing ids on titles are preserved', () async {
      PaperToolbar toolbar = fixture('title-with-id');
      await new Future(() {});
      expect(toolbar.getAttribute('aria-labelledby'), isNotNull,
          reason: 'should have aria-labelledby');
      expect(toolbar.querySelector('.title').id, equals('title'),
          reason: 'id should be preserved');
    });

    test('multiple children with .title becomes the label', () async {
      PaperToolbar toolbar = fixture('multiple-titles');
      await new Future(() {});

      expect(toolbar.getAttribute('aria-labelledby'), isNotNull,
          reason: 'should have aria-labelledby');

      List titles = toolbar.querySelectorAll('.title');

      String ids = titles.map((title) => title.id).join(' ');

      expect(toolbar.getAttribute('aria-labelledby'), equals(ids),
          reason: 'aria-labelledby should have the id of all .title elements');
    });
  });
}
