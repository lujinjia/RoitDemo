<todo class="todoContent">

    <h3>{ getCurrentDate()} 待办事项</h3>

    <form onsubmit={ add }>
        <select name="待办类型" id="todoType">
            <option value="0" selected >工作</option>
            <option value="1">生活</option>
            <option value="2">自我提高</option>
        </select>
        <input ref="input" onkeyup={ edit }>
        <input ref="time" type="time" blur={ editDate }>
        <button disabled={ !text }>增加</button>
        <button onclick={search}>搜索</button>
    </form>

    <button id="msgBtn" style="display: none;"></button>

    <div>
        <div>
            <span><a onclick={showAll} href="#" class="todoItem">全部事项</a></span>
            <span><a onclick={showUndo} href="#" class="todoItem">待办</a></span>
            <span><a onclick={showDone} href="#" class="todoItem">已完成</a></span>
        </div>
        <ul>
            <li each={ items.filter(whatShow) }>
                <div>类型：{filterType(type)}</div>
                <label class={ completed: done }>
                    <input type="checkbox" checked={ done } onclick={ parent.toggle }> { title }
                    <button type="button" onclick={upTodo}>置顶</button>
                    <button type="button" onclick={deleteTodo}>删除</button>
                </label>
                <div class={ completed: done } style="margin-left: 25px;">
                    预计完成时间： { filterTime(wishTime) }
                </div>
                <div class={ completed: done } style="margin-left: 25px;">
                    实际完成时间： { filterTime(actualTime) }
                </div>

            </li>
        </ul>
    </div>


<!-- this script tag is optional -->
<script>

    //opts是父级传递的参数
    this.items = opts.items;
    this.todoStatus = false;
    var that = this;

    this.on('mount', function() {
        //获取chrome桌面通知权限

        if(Notification && Notification !== 'granted') {
            Notification.requestPermission(function(status){
                if(Notification.permission !== status) {
                    Notification.permission = status;
                }
            });
        }


        var button = document.getElementById('msgBtn');

        button.addEventListener('click', function() {

            var item = that.todoItem;

            var options = {
                dir: 'ltr',
                lang: 'utf-8',
                icon: 'http://img.zcool.cn/community/01c14556186e1e32f8755701c6b9a8.gif',
                body: '任务内容：' + item.title + '\n' + '任务截止时间：' + that.transTimeStamp(item.wishTime)
            };

            if(Notification && Notification.permission === 'granted') {

                var n = new Notification('任务到期提醒', options);
                n.onshow = function(){
                    item.hasCheck = true;
                };
                n.onclick = function(){
                    //跳转到待办事项中，通过URI路径
                    //window.href = '';
                }
            }
        });

        //每隔10秒检测是否有任务即将结束，如果是，则发送桌面通知
        setInterval(function(){

            //待办事项提醒
            that.items.map(function(item){
                if((item.wishTime - new Date().getTime()< 1800000) && !(item.hasCheck)) {
                    that.todoItem = item;
                    document.getElementById('msgBtn').click();
                }
            });

        }, 5000)
    });



    transTimeStamp(timeStamp)
    {
        var date = new Date(timeStamp);
        Y = date.getFullYear() + '-';
        M =  date.getMonth()+1 + '-';
        D = date.getDate() + ' ';
        h = date.getHours()+1 < 10 ? '0'+(date.getHours()) + ':': date.getHours() + ':';
        m = date.getMinutes()+1 < 10 ? '0'+(date.getMinutes()): date.getMinutes();
        var time = Y+M+D+h+m;
        return time;
    }

    showAll()
    {
        this.items = opts.items;
    }

    //已完成、未完成、全部事项标签显示控制
    showUndo()
    {
        this.items = opts.items;
        this.items = this.items.filter(function(value){
            return !(value.done);
        });
    }

    showDone()
    {
        this.items = opts.items;
        this.items = this.items.filter(function(value){
            return value.done;
        });
    }

    filterType(type)
    {
        if(type === '1') {
            return '生活';
        } else if(type === '0'){
            return '工作';
        } else {
            return '自我提高';
        }
    }


    //置顶待办事项
    upTodo(event)
    {
        var item = event.item;
        var that = this;
        this.items.map(function (data, index) {
            if (data.id === item.id) {
                that.items.splice(index, 1);
                that.items.unshift(item);
            }
        });
    }

    //输入框响应事件
    edit(e)
    {
        this.text = e.target.value;
        this.type = document.getElementById('todoType').value;
    }

    editDate(e)
    {

        debugger
        this.time = e.target.value;
    }

    //增加代办事项
    add(e)
    {
        if (this.text) {
            if(!this.time) {
                this.time = new Date().getTime() + 3600000;
            }
            localStorageUtils.methods.addItem({title: this.text, wishTime: this.time, type: this.type});
            this.text = this.refs.input.value = '';
            this.time = this.refs.time.value = '';
        }
        e.preventDefault();
    }
    search(event)
    {
        if(this.text) {
            localStorageUtils.methods.search(this.text);
        }
    }

    //获取当前时间
    getCurrentDate()
    {
        return new Date().toLocaleDateString();
    }

    filterTime(time)
    {
        if (time) {
            var date = new Date(parseInt(time));
            var showTime = date.toLocaleDateString() + date.toLocaleTimeString();
            return showTime;
        } else {
            return '尚未完成';
        }

    }

    //删除代办事项
    deleteTodo(event)
    {
        var item = event.item;
        localStorageUtils.methods.deleteItem(item.id);
    }

    //过滤是否显示
    whatShow(item)
    {
        return !item.hidden
    }

    //是否完成
    onlyDone(item)
    {
        return item.done
    }

    //代办事项点击事件
    toggle(e)
    {
        var item = e.item;
        if (item.done) {
            item.actualTime = new Date().getTime();
        }

        item.done = !item.done
        return true
    }

</script>

</todo>
