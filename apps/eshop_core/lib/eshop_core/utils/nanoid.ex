defmodule EshopCore.Utils.Nanoid do
  def gen_nano_id(number \\ 10) do
    Nanoid.generate(number, "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ")
  end
end
