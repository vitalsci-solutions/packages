## NEXT

* Updates minimum supported SDK version to Flutter 3.10/Dart 3.0.

## 0.2.2

* Adds the following new fields to `IdConfiguration`:
  * `login_hint`, `hd` as auto-select hints for users with multiple accounts/domains.
  * `use_fedcm_for_prompt` so FedCM can be enabled.

## 0.2.1+1

* Adds pub topics to package metadata.
* Updates minimum supported SDK version to Flutter 3.7/Dart 2.19.

## 0.2.1

* Relaxes the `renderButton` API so any JS-Interop Object can be its `target`.
* Exposes the `Button*` configuration enums, so the rendered button can be configured.

## 0.2.0

* Adds `renderButton` API to `id.dart`.
* **Breaking Change:** Makes JS-interop API more `dart2wasm`-friendly.
  * Removes external getters for function types
  * Introduces an external getter for the whole libraries instead.
  * Updates `README.md` with the new way of `import`ing the desired libraries.

## 0.1.1

* Add optional `scope` to `OverridableTokenClientConfig` object.
* Mark some callbacks as optional properly.

## 0.1.0

* Initial release.
