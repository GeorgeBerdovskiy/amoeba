# Buffer Pool

## Pool

## Page
The page is divided into two regions that grow toward each other from opposite ends, separated by contiguous free space.

The top region contains the **header** and the **slot directory**, whereas the bottom region contains the **records**.

### Header

| Field | Description |
| ----- | ----------- |
| Slot Array End | Pointer to the end of the slot array. |
| Record Array Start | Pointer to the start of the record array. |
| Dirty Bit | Indicates if the page is dirty. |

### Slot Array

Array of slots `(O, L)` where `O` is the offset of the record, in bytes, from the beginning of the page, and `L` is the length of the array. For efficiency, we say that a record is deleted if `L` is zero (that is our tombstone marker).