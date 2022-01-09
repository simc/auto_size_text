## 4.0.0
- Added `AutoSizeBuilder`, `SelectableAutoSize`, `AutoSizeTextField` and `AutoSizeGroupBuilder`
- Added `textWidthBasis` and `textHeightBehavior`
- Changed default `wordWrap` to `false`
- Improved performance
- Fixed intrinsics handling
- Fixed `wordWrap` calculation for rich text

## 3.0.0
- Upgraded to null safety

## 2.1.0
- Added `textKey` parameter

## 2.0.2+1
- Fixed screenshots

## 2.0.2
- Fixed bug where `textScaleFactor` was not taken into account (thanks @Kavantix)

## 2.0.1
- Allow fractional font sizes again
- Fixed bug with `wrapWords` not working

## 2.0.0+2
- Added logo

## 2.0.0
- Significant performance improvements
- Prevent word wrapping using `wordWrap: false`
- Replacement widget in case of text overflow: `overflowReplacement`
- Added `strutStyle` parameter from `Text`
- Fixed problem in case the `AutoSizeTextGroup` changes
- Improved documentation
- Added many more tests

## 1.1.2
- Fixed bug where system font scale was applied twice (thanks @jeffersonatsafe)

## 1.1.1
- Fixed bug where setting the style of a `TextSpan` to null in `AutoSizeText.rich` didn't work (thanks @Koridev)
- Allow `minFontSize = 0`

## 1.1.0
- Added `group` parameter and `AutoSizeGroup` to synchronize multiple `AutoSizeText`s
- Fixed bug where `minFontSize` was not used correctly
- Improved documentation

## 1.0.0
- Library is used in multiple projects in production and is considered stable now.
- Added more tests

## 0.3.0
- Added textScaleFactor property with fallback to `MediaQuery.textScaleFactorOf()` (thanks @jeroentrappers)

## 0.2.2
- Fixed tests
- Improved documentation

## 0.2.1
- Fixed problem with `minFontSize` and `maxFontSize` (thanks @apaatsio)

## 0.2.0
- Added support for Rich Text using `AutoSizeText.rich()` with one or multiple `TextSpan`s.
- Improved text size calculation (using `textScaleFactor`)

## 0.1.0
- Fixed documentation (thanks @g-balas)
- Added tests

## 0.0.2
- Fixed documentation
- Added example

## 0.0.1
- First Release
