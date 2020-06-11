# defmodule MyBroadway do
#   use Broadway

#   def start_link() do
#     Broadway.start_link(__MODULE__,
#       name: __MODULE__,
#       producer: [
#         module: {Broadway.DummyProducer, []}
#       ],
#       processors: [
#         default: []
#       ],
#       batchers: [
#         default: [
#           batch_size: 2
#         ]
#       ]
#     )
#   end

#   @impl true
#   def handle_message(_processor, message, _context) do
#     message
#   end

#   @impl true
#   def handle_batch(_batcher, messages, _batch_info, _context) do
#     messages
#   end
# end

# ExUnit.start()

defmodule MyBroadwayTest do
  use ExUnit.Case, async: true

  test "foo" do
    # {:ok, pid} = MyBroadway.start_link()

    ref = Broadway.test_messages(FidelityRuleEngine.Consumer, [1, 2, 3], batch_mode: :flush)
    assert_receive {:ack, ^ref, [%{data: 1}], []}
    assert_receive {:ack, ^ref, [%{data: 2}], []}
    assert_receive {:ack, ^ref, [%{data: 3}], []}

    ref = Broadway.test_messages(FidelityRuleEngine.Consumer, [1, 2, 3], batch_mode: :bulk)

    # this is sent out almost immediately because it filled the batch size of 2
    assert_receive {:ack, ^ref, [%{data: 1}, %{data: 2}], []}

    # for this we wait until batch timeout is reached
    assert_receive {:ack, ^ref, [%{data: 3}], []}, 2000
  end
end
