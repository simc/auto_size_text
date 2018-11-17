import 'package:grinder/grinder.dart';

void main(List<String> args) => grind(args);

@DefaultTask('Combine tasks for continous integration')
@Depends('analyse', 'checkformat')
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

@Task('Check dartfmt for all Dart source files')
void checkformat() {
  if (DartFmt.dryRun(existingSourceDirs))
    fail('Code is not properly formatted. Run `grind format`');
}

@Task('Apply dartfmt to all Dart source files')
void format() => DartFmt.format(existingSourceDirs);
