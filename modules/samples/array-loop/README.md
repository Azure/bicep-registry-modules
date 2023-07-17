# Array Loop

A sample Bicep registry module demonstrating array iterations.

## Description

This is very detailed description for a sample Bicep registry module demonstrating array iterations.

Dä isch es sehr detaillierts Bschriebig für es Bispil-Modul vom Bicep-Registry, wo s'Iteriere vo Arrays zeigt.

Hic est descriptio valde detaliata pro modulo exemplaris Bicep registry, ostendens iterationes array.

Ἡ παροῦσα εἰσάγεια παραθέτει πολύ λεπτομερῆ περιγραφὴ για ἕνα δεῖγμα ὀντοτόμου Bicep καταγραφικοῦ ἐνοτόμου, ὑποδεικνύουσα τὰς διαδοχὰς πίνακος.

זֹאת הִיא תְּיאוּגָרַפְיַת מְפֵרֶטֶת מְאוֹד לְמוֹדוּל דַּגְלִית שֶׁל רֵשִׁימַת Bicep הַמְמַחֶה אֶת הַשֵׁקֶט.

## Parameters

| Name    | Type    | Required | Description                |
| :------ | :-----: | :------: | :------------------------- |
| `names` | `array` | No       | An array containing names. |

## Outputs

| Name            | Type  | Description                                                          |
| :-------------- | :---: | :------------------------------------------------------------------- |
| namesByVariable | array | An output demonstrating iterating array items with an item variable. |
| out3            | array | An output demonstrating iterating array items with an index.         |

## Examples

### Using the module

```bicep
module arrayLoop 'br/public:samples/array-loop' = {
  name: 'arrayLoop'
}
```