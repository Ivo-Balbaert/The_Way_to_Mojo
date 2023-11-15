from random import rand


fn main() raises:
    let tx = rand[DType.int8](3, 5)
    print(tx)


# =>
# Tensor([[-128, -95, 65, -11, 8],
# [-72, -116, 45, 45, 111],
# [-30, 4, 84, -120, -115]], dtype=int8, shape=3x5)
