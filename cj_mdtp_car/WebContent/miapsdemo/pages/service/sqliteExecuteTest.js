require(
    [
        "jquery",
        "miaps",
        "miapspage",
        "miapswp",
        "tui-grid"
    ], function ($, miaps, miapsPage, miapsWp, tui) {
        function init() {
            // back button event
            $('.back_btn').on('click', function (e) {
                e.preventDefault();
                miapsPage.back()
            })

            // home button event
            $(".home_btn").on("click", function (e) {
                e.preventDefault();
                miapsPage.goTopPage();
            });

            // execute button event
            $('#btn-execute').on('click', service.executeQuery)

            // 커넥터 통신을 위한 set device info
            miaps.setDeviceInfo('test00001', '', '', '', 'test00001')

            // set sql sample text
            cmm.initTextArea()

            // check table
            service.checkSqliteTable()
        }

        // 전역 변수
        var globalValue = {
            indexNum: 0,
            perPage: 20,
            dbFileNm: 'sqlite.testdb.db',
            tableNm: 'miaps_sample',
            constSqlFolder: '/miapsdemo/templates/query/',
            createTableQuery: 'create_sample_table.sql',
            insertDataQuery: 'insert_sample_data.sql',
            deleteDataQuery: 'delete_sample_data.sql'
        }

        var service = {
            // execute query
            executeQuery: function () {
                miaps.cursor(null, 'wait', true)

                var sql = $('#qry-area').val()
                var dmlMode = ''

                // set dml mode
                if (sql) {
                    if (sql.indexOf('select') === 0) {
                        dmlMode = 'select'
                    } else if (sql.indexOf('insert') === 0
                        || sql.indexOf('update') === 0
                        || sql.indexOf('delete') === 0
                        || sql.indexOf('create') === 0
                        || sql.indexOf('drop') === 0
                        || sql.indexOf('alter') === 0
                    ) {
                        dmlMode = 'execute'
                    } else {
                        cmm.setResultArea('Not Allow Query')
                        return
                    }
                    console.log('dml mode: ' + dmlMode)

                    // query 실행
                    miapsWp.callQuery(
                        dmlMode,
                        globalValue.dbFileNm,
                        sql
                    ).then(function (data) {
                        var obj = miaps.parse(data)
                        console.log(obj)
                        if (obj.msg && !obj.res) {
                            cmm.setResultArea(obj.msg)
                            return
                        }
                        if (dmlMode === 'select') {
                            // select일때만 grid 그리기
                            cmm.drawGrid(obj)
                        } else {
                            // 그 외에는 beautify 하여 result 에 추가
                            cmm.setResultArea(miaps.beautify(obj))
                        }
                        miaps.cursor(null, 'default')
                    })
                }
            },
            // sqlite 테이블 있는지 검사
            checkSqliteTable: function () {
                var checkSql
                    = "select count(1) as cnt "
                    + "from sqlite_master "
                    + "where name = \'"
                    + globalValue.tableNm
                    + "\'"

                miapsWp.callQuery(
                    'select',
                    globalValue.dbFileNm,
                    checkSql
                ).then(service.checkSqliteTableCallback)
            },
            // table 유무에 따른 콜백 함수
            checkSqliteTableCallback: function (data) {
                var obj = miaps.parse(data)
                console.log(miaps.beautify(obj))

                var cnt = obj.res[0].cnt;
                // 테이블이 없으면 만든다.
                if (cnt == 0) {
                    console.log('Create Table')
                    var createFile
                        = globalValue.constSqlFolder
                        + globalValue.createTableQuery
                    cmm.callQuery(createFile,
                        'execute',
                        service.insertSqliteSampleData)
                } else {
                    //테이블이 있으면 기존 데이터 삭제
                    console.log('Table is exist.')
                    service.deleteSqliteSampleData()
                }
            },
            insertSqliteSampleData: function () {
                console.log('insert data')
                var insertFile
                    = globalValue.constSqlFolder
                    + globalValue.insertDataQuery
                cmm.callQuery(insertFile, 'execute')
            },
            deleteSqliteSampleData: function () {
                console.log('delete data')
                var deleteFile
                    = globalValue.constSqlFolder
                    + globalValue.deleteDataQuery
                cmm.callQuery(
                    deleteFile,
                    'execute',
                    service.insertSqliteSampleData)
            }
        }

        var cmm = {
            callQuery: function (file, mode, cbFunc) {
                if (!cbFunc) {
                    cbFunc = function (data) {
                        cmm.setResultArea(miaps.beautify(data));
                    }
                }
                $.get(file, function (query) {
                    miapsWp.callQuery(
                        mode,
                        globalValue.dbFileNm,
                        query,
                        cbFunc
                    )
                })
            },
            drawGrid: function (data) {
                var cols = Object.keys(data.res[0])
                console.log(cols)

                var gridObj = {
                    data: [],
                    columns: [],
                    header: {
                        height: 50
                    }
                }
                if (cols) {
                    for (var i = 0; i < cols.length; i++) {
                        gridObj.columns[i] = {}
                        gridObj.columns[i].header = cols[i]
                        gridObj.columns[i].name = cols[i]
                        gridObj.columns[i].width = '150'
                    }

                    gridObj.data = data.res

                    var dataSourceOptions = {
                        el: document.getElementById('dataSourceGrid'),
                        columns: gridObj.columns,
                        data: gridObj.data,
                        header: gridObj.header,
                        bodyHeight: 250,
                        scrollX: true,
                        scrollY: true,
                        pageOptions: {
                            useClient: true,
                            type: 'scroll',
                            perPage: globalValue.perPage
                        },
                        hideLoadingBar: false
                    }

                    console.log(gridObj)

                    // Grid 생성
                    $('#dataSourceGrid').children().remove()
                    var dataSourceGrid = new tui(dataSourceOptions)

                    // 데이터가 모두 채워졌을 때 이벤트
                    dataSourceGrid.on('onGridUpdated', function (e) {
                        console.log('onGridUpdated')
                    })
                }

                // dataSourceGrid.resetData(obj)
                console.log('set data')
            },
            initTextArea: function () {
                $('#qry-area').text('select * from miaps_sample limit 5')
            },
            setResultArea: function (data) {
                var $grid = $('#dataSourceGrid')
                $grid.children().remove()
                $grid.append(
                    '<textarea class="result-area"></textarea>'
                )
                $('.result-area').text(data)
            }
        }

        init()
    })