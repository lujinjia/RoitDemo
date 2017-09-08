<todo class="todoContent">

    <h3>{ getCurrentDate()} 待办事项</h3>

    <form>
        <select name="待办类型" id="todoType">
            <option value="0" selected >工作</option>
            <option value="1">生活</option>
            <option value="2">自我提高</option>
        </select>
        <input ref="input" onkeyup={ edit } onenter={ add }>
        <button disabled={ !text } onclick={ add }>
        <svg class="icon" aria-hidden="true">
            <use xlink:href="#icon-add"></use>
        </svg>
        增加
        </button>
        <button onclick={ search }>
            <svg class="icon" aria-hidden="true">
                <use xlink:href="#icon-search_light"></use>
            </svg>
    搜索</button>
    </form>

    <button id="msgBtn" style="display: none;"></button>

    <div>
        <div>
            <li each={types} onclick={showType} class={ typeItemSelect: isHover, typeItem: true } >
                { title }
            </li>

        </div>
        <ul>
            <li each={ items }>
                <div class="todoItem">
                    <label >
                        <input type="checkbox" checked={ done } onclick={ toggle } hidden>
                        <svg  aria-hidden="true" class={hide: done, icon: true}>
                            <use xlink:href="#icon-weigouxuan"></use>
                        </svg>
                        <svg aria-hidden="true" class={hide: !done, icon: true}>
                            <use xlink:href="#icon-yigouxuan"></use>
                        </svg>
                    </label>

                    <span style="font-size: 12px; color: #ccc;">{filterType(type)} - </span>
                    <span contenteditable="true" class={ completed: done, todoTitle: true }  onblur={ editTodo }>
                        { title }
                    </span>

                    <span style="cursor: pointer;">
                        <svg class="icon" aria-hidden="true" onclick={upTodo}>
                            <use xlink:href="#icon-top"></use>
                        </svg>
                    </span>

                    <span style="cursor: pointer;">
                        <svg class="icon" aria-hidden="true" onclick={deleteTodo}>
                            <use xlink:href="#icon-move"></use>
                        </svg>
                    </span>
                </div>

            </li>
        </ul>
    </div>


<!-- this script tag is optional -->
<script>

    //opts是父级传递的参数
    this.items = opts.items;
    this.items = this.items.filter(function(value) {
        return !value.done
    });
    this.types = opts.types;

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

    //已完成、未完成、全部事项标签显示控制
    showType(e)
    {
        var item = e.item;
        var type = item.id;
        this.items = opts.items;
        if(type === '1') {
            this.items = this.items.filter(function(value) {
                return value.done;
            });
        } else {
            this.items = this.items.filter(function(value) {
                return !value.done
            });
        }
        opts.types.map(function(value) {
            value.isHover = false;
        });
        item.isHover = true;
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


        var itemIndex;
        var item = event.item;
        var itemTypes = this.items.map((data, index)=> {
           if(data.type === item.type) {
                this.items.splice(index, 1, item);
            }
        });

       itemTypes.map((data, index)=>{
        if (data.id === item.id) {
            itemTypes.splice(index, 1);
            itemTypes.unshift(item);
        }
       });

        localStorageUtils.methods.updateType(item.type, itemTypes);
    }

    //修改待办事项
    editTodo(event) {
        var text = event.target.innerText.trim();
        var item = event.item;
        item.title = text;
        localStorageUtils.methods.setItem(item.key, item);
    }

    //输入框响应事件
    edit(e)
    {
        this.text = e.target.value;
        this.type = document.getElementById('todoType').value;
    }

    //增加代办事项
    add(e)
    {

        if (this.text) {
            var item = {title: this.text, createTime: new Date().getTime(), type: this.type, done: false};
            this.items.push(item);
            localStorageUtils.methods.addItem(item);
            this.text = this.refs.input.value = '';
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
        var index = localStorageUtils.methods.getIndex(item.id);
        this.items.splice(index, 1);
        localStorageUtils.methods.deleteItem(index);
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
            item.closeTime = new Date().getTime();
        }
        item.done = !item.done;
        this.items.map(function(value) {
            if(value.id === item.id) {
                value = item;
            }
        });
        localStorageUtils.methods.setItem(item.key, item);
        return true
    }

</script>

</todo>
