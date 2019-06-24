When the Minimum Layer Time is reached, the print head will slow down in order to prevent printing faster than the Minimum Layer Time. This way the previous layer gets time to cool down and solidify before the next layer is put on top. The print head is allowed to slow down until the Minimum Speed is reached.

If this setting is enabled and the print head should move slower than the Minimum Speed in order to maintain the Minimum Layer Time, then the print head will move up slightly after printing the layer. It will then wait for a while until the Minimum Layer Time is reached, before starting with the next layer.
![When the minimum layer time is reached, the head may lift up](cool_fan_speed.svg)
The print head will always move up by 3mm. There is no setting to configure this at the moment.