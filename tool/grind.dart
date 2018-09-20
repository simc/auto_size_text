import 'dart:io';

import 'package:grinder/grinder.dart';

void main(List<String> args) => grind(args);

@DefaultTask('Combine tasks for continous integration')
@Depends('analyse', 'test', 'doc', 'coverage', 'checkformat')
void make() {
  // Nothing to declare here
}

@Task("Analyze lib source code")
void analyse() => Analyzer.analyze(existingSourceDirs, fatalWarnings: true);

@Task('Generate dartdoc')
void doc() {
  var docPath = FilePath('doc/api');
  if (docPath.exists) docPath.delete();
  DartDoc.doc();
}

@Task('Run tests')
void test() => PubApp.local('test').run([]);

@Task('Check dartfmt for all Dart source files')
void checkformat() {
  if (DartFmt.dryRun(existingSourceDirs))
    fail('Code is not properly formatted. Run `grind format`');
}

@Task('Apply dartfmt to all Dart source files')
void format() => DartFmt.format(existingSourceDirs);

@Task('Gather and send coverage data.')
void coverage() {
  final String coverageToken = Platform.environment['COVERAGE_TOKEN'];

  if (coverageToken != null) {
    PubApp coverallsApp = new PubApp.global('dart_coveralls');
    coverallsApp.run([
      'report',
      '--retry',
      '2',
      '--exclude-test-files',
      '--token',
      coverageToken,
      'test/all.dart',
    ]);
  } else {
    log('Skipping coverage task: no environment variable `COVERAGE_TOKEN` found.');
  }
}
