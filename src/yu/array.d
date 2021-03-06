module yu.array;

/**
 * 移除数组中元素，并且数组下标前移。
 * return： 移除的个数
 * 注： 对数组的长度不做处理
*/
size_t arrayRemove(E)(ref E[] ary, E e) {
    size_t len = ary.length;
    size_t site = 0;
    size_t rm = 0;
    for (size_t j = site; j < len; ++j) {
        if (ary[j] != e) {
            ary[site] = ary[j];
            site++;
        } else {
            rm++;
        }
    }
    return rm;
}

ptrdiff_t findIndex(E)(in E[] ary, in E e) {
    import std.algorithm.searching : find;

    E[] rv = find(ary, e);
    if (rv.length == 0)
        return -1;
    return ary.length - rv.length;
}

@trusted final class IAppender(CHAR, Alloc) {
    import std.experimental.allocator.common;
    import yu.container.vector;

    alias Buffer = Vector!(CHAR, Alloc);
    alias InsertT = Buffer.InsertT;
    enum isStaticAlloc = (stateSize!Alloc == 0);

    static if (isStaticAlloc) {
        this(size_t initSize) {
            buffer = Buffer(initSize);
        }

    } else {
        this(size_t initSize, Alloc alloc) {
            buffer = Buffer(initSize, alloc);
        }

    }

    pragma(inline) void put(InsertT ch) {
        buffer.insertBack(ch);
    }

    pragma(inline) void put(InsertT[] chs) {
        buffer.insertBack(chs);
    }

	pragma(inline) @property CHAR[] data(bool rest = false) {
        return buffer.data(rest);
    }

	pragma(inline) @property CHAR[] bufferData(){
		return data(false);
	}

    Buffer buffer;
}

unittest {
    import std.stdio;

    int[] a = [0, 0, 0, 4, 5, 4, 0, 8, 0, 2, 0, 0, 0, 1, 2, 5, 8, 0];
    writeln("length a  = ", a.length, "   a is : ", a);
    int[] b = a.dup;
    auto rm = arrayRemove(b, 0);
    b = b[0 .. ($ - rm)];
    writeln("length b  = ", b.length, "   b is : ", b);
    assert(b == [4, 5, 4, 8, 2, 1, 2, 5, 8]);

    int[] c = a.dup;
    rm = arrayRemove(c, 8);
    c = c[0 .. ($ - rm)];
    writeln("length c  = ", c.length, "   c is : ", c);

    assert(c == [0, 0, 0, 4, 5, 4, 0, 0, 2, 0, 0, 0, 1, 2, 5, 0]);

    int[] d = a.dup;
    rm = arrayRemove(d, 9);
    d = d[0 .. ($ - rm)];
    writeln("length d = ", d.length, "   d is : ", d);
    assert(d == a);

	import std.experimental.allocator.mallocator;

	alias MAppter = IAppender!(char,Mallocator);

	MAppter ma = new MAppter(64);
	ma.put("hahahah");
	ma.put("wsafdsafsdftgdgff");
	string bdata = cast(string)ma.bufferData;
	writeln("bdata = ", bdata);
	assert(bdata == "hahahahwsafdsafsdftgdgff");
}
