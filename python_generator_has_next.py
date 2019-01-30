

# Wrapper class around an iterator that exposes as "has_next" function

class NoNextItem:
    pass

class IterHasNext:
    # this works by accessing and storing the next value of the iterator, and reyielding it when next is called externally

    def __init__(self, iter):
        self._iter = iter
        self._next = NoNextItem

    def __iter__(self):
        return self

    def __next__(self):
        if self._next is not NoNextItem:
            return_value = self._next
            self._next = NoNextItem
            return return_value
        return next(self._iter)

    def has_next(self):
        if self._next is not NoNextItem:
            return True

        try:
            self._next = self.__next__()
            return True
        except StopIteration:
            return False

def test():
    base_iter = iter(range(10))
    my_iter = IterHasNext(base_iter)

    has_next = my_iter.has_next()

    while has_next:
        print(next(my_iter))
        has_next = my_iter.has_next()

    print('end')

if __name__ == '__main__':
    test()
