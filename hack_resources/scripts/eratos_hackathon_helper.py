def download_all_non_gridded_files_from_space(adapter = None, space_ern = None,destination = '.'):

        res = adapter.Resource(ern = space_ern)

        if str(res.type()) != 'ern:e-pn.io:schema:space':
            raise ValueError("The provided ERN does not correspond to an Eratos space ERN")

        res_col = adapter.Resource(ern = res.prop('collection'))

        for item in res_col.prop('items'):

            item_res = adapter.Resource(ern = item['ern'])
            print(item_res.prop('name'))
            #print(item_res.data())
            try:
                lst = item_res.data().list_objects()
            except Exception as e:
                print("Could not find data files for: ", item_res.prop('name'))
                print("Will skip and continue")
                continue
            for ob in lst:

                #print(ob)
                if ob['key'].endswith(".nc"):
                    continue
                else:

                    item_res.data().fetch_object(ob['key'], dest=destination)

                    print("Downloaded: ", ob['key'])


def download_files_for_dataset_block_ern(adapter = None, block_ern = None,destination = '.'):

    item_res = adapter.Resource(ern = block_ern)

    if str(item_res.type()) != 'ern:e-pn.io:schema:block':
        raise ValueError("The provided ERN does not correspond to an Eratos Block ERN")


    print(item_res.prop('name'))
    #print(item_res.data())
    try:
        lst = item_res.data().list_objects()
    except Exception as e:
        print("Could not find data files for: ", item_res.prop('name'))
       
    for ob in lst:

        #print(ob)
        if ob['key'].endswith(".nc"):
            print("Will not download files that can be accessed through the gridded interface", item_res.prop('name'))
            continue
        else:

            item_res.data().fetch_object(ob['key'], dest=destination)

            print("Downloaded: ", ob['key'])