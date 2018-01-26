defmodule Dice do
  @moduledoc """
  Dice is a simple (mostly) D&D compatible dice rolling mechanism that makes use
  of Rnum.random for random die result generation.

  All seven dice from the standard off the shelf set is available using atoms
  to describe their type:

    :d4, :d6 :d8, :d10, :d12, :d100

  To roll a d20, simply:
    roll(:d20)

  More than one :d20 can be rolled at a time, returning a list:
    roll(2, :d20)
    [15, 12]

  Adding new dice:

  To add new dice, provide a function called roll_dice(type) where type is
  some argument (hopefully an atom) that returns some dice rolling result.
  For reference, the implementation of d20 is as follows:
    def roll_die(:d20),  do: Enum.random(1..20)

"""

  def roll(type), do: roll(1, type)
  def roll(count \\ 2, type \\ :d20), do: roll(count, type, [])
  def roll(0, type, acc), do: acc

  def roll(count, type, acc) do
    roll(count - 1, type, [ roll_die(type) ] ++ acc)
  end

  def roll_die(:d4),   do: Enum.random(1..4)
  def roll_die(:d6),   do: Enum.random(1..6)
  def roll_die(:d8),   do: Enum.random(1..8)
  def roll_die(:d10),  do: Enum.random(1..10)
  def roll_die(:d12),  do: Enum.random(1..12)
  def roll_die(:d20),  do: Enum.random(1..20)
  def roll_die(:d100), do: round(Enum.random(0 .. 90) / 10) * 10
end