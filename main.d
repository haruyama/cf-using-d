module cf.main;

import std.stdio, std.string, std.array, std.conv, std.algorithm, std.range;

immutable ulong MAX_NUMBER_OF_RESULT_PER_ITEM = 30;

ulong[][ulong] readInput() {
    ulong[][ulong] user_items;
    foreach(string line; lines(stdin)) {
        ulong[] row = array(map!"parse!ulong(a)"(filter!"a.length > 0"(split(strip(line), ","))));
        if (row.length > 1) {
            user_items[row[0]] = row[1 .. $];
        }
    }
    return user_items;
}


ulong[][ulong] transpose(ulong[][ulong] user_items) {
    ulong[][ulong] item_users;
    foreach (user, items; user_items) {
        foreach(item; items) {
            item_users[item] ~= user;
        }
    }
    foreach (item; item_users.keys) {
        item_users[item] = array(sort(item_users[item]));
    }
    return item_users;
}


double tanimoto(ulong[] a, ulong[] b) {
    if (a.empty || b.empty) {
        return 0;
    }
    auto i = array(setIntersection(a, b));
    return (1.0 * i.length) / (a.length + b.length - i.length);
}


struct CFResult {
    ulong item;
    double value;
    this(ulong i, double r) {
        item = i;
        value = r;
    }
    string toString() {
        return format("%d|%f", item, value);
    }
}


CFResult[][ulong] cf(ulong[][ulong] item_users, ulong max_number_of_result_per_item) {
    CFResult[][ulong] result_hash;
    foreach (item1, users1 ; item_users) {
        foreach (item2, users2 ; item_users) {
            if (item1 <= item2) continue;
            auto t = tanimoto(users1, users2);
            if (t > 0) {
                result_hash[item1] ~= CFResult(item2, t);
                result_hash[item2] ~= CFResult(item1, t);
            }
        }
    }

    foreach (item, ref results; result_hash) {
        if (max_number_of_result_per_item > results.length) {
            sort!("a.value > b.value")(results);
        } else {
            partialSort!("a.value > b.value")(results, max_number_of_result_per_item);
            results.length = max_number_of_result_per_item;
        }
    }
    return result_hash;
}


void writeResultHash(CFResult[][ulong] result_hash) {
    foreach (item; sort(result_hash.keys)) {
        write(item, ":");
        writeln(joiner(map!"a.toString()"(result_hash[item]), ","));
    }

}


void main() {
    auto user_items = readInput();
    auto item_users = transpose(user_items);
    auto result_hash = cf(item_users, MAX_NUMBER_OF_RESULT_PER_ITEM);
//    auto result_hash = cf(item_users, 2);
    writeResultHash(result_hash);
}
