<h1 style="color: steelblue;">⚠️ Upcoming changes ⚠️</h1>

This module has been retired without a replacement module in Azure Verified Modules (AVM).

For more information, see the informational notice [here](https://github.com/Azure/bicep-registry-modules?tab=readme-ov-file#%EF%B8%8F-upcoming-changes-%EF%B8%8F).

# Array Loop

A sample Bicep registry module demonstrating array iterations.

## Details

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

| Name              | Type    | Description                                                          |
| :---------------- | :-----: | :------------------------------------------------------------------- |
| `namesByVariable` | `array` | An output demonstrating iterating array items with an item variable. |
| `out3`            | `array` | An output demonstrating iterating array items with an index.         |

## Examples

### Using the module

```bicep
module arrayLoop 'br/public:samples/array-loop' = {
  name: 'arrayLoop'
}
```
