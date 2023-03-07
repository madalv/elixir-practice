n = MyNode.start(nil, 1, nil)

n1 = MyNode.start(nil, 2, nil)
n2 = MyNode.start(nil, 3, nil)

MyNode.set_next(n, n1)
MyNode.set_prev(n1, n)
MyNode.set_prev(n2, n1)
MyNode.set_next(n1, n2)

ActorList.traverse([n, n1, n2])
list = ActorList.reverse([n, n1, n2])
ActorList.traverse(list)

receive do
  msg -> IO.inspect(msg)
end
