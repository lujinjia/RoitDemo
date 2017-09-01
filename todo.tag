
<todo class="todoContent">

  <h3>{ getCurrentDate()} 代办事项</h3>

  <form onsubmit={ add }>

    <input ref="input" onkeyup={ edit }>

    <button disabled={ !text }>
        增加
    </button>


    <button type="button" disabled={ items.filter(onlyDone).length == 0 } onclick={ removeAllDone }>
      删除
    </button>

  </form>

  <ul>
    <li each={ items.filter(whatShow) }>
      <label class={ completed: done }>
        <input type="checkbox" checked={ done } onclick={ parent.toggle }> { title }
      </label>
      <div class={ completed: done } style="margin-left: 25px;">
          创建时间： { filterTime(createTime) }
      </div>
      <div class={ completed: done } style="margin-left: 25px;">
          完成时间： { filterTime(closeTime) }
      </div>
    </li>
  </ul>

<!-- this script tag is optional -->
<script>

  //opts是父级传递的参数
  this.items = opts.items;

  //输入框响应事件
  edit(e) {
    this.text = e.target.value;
  }

  //增加代办事项
  add(e) {
    if (this.text) {
      this.items.push({ title: this.text, createTime: new Date().getTime() });
      this.text = this.refs.input.value = '';
    }
    e.preventDefault();
  }

  //获取当前时间
  getCurrentDate() {
      return new Date().toLocaleDateString();
  }

  filterTime(time) {
      if(time) {
        var date = new Date(parseInt(time));
        var showTime = date.toLocaleDateString() + date.toLocaleTimeString();
        return showTime;
      } else {
        return '尚未完成';
      }

  }

  //删除代办事项
  removeAllDone(e) {
    this.items = this.items.filter(function(item) {
      return !item.done
    })
  }

  //过滤是否显示
  whatShow(item) {
    return !item.hidden
  }

  //是否完成
  onlyDone(item) {
    return item.done
  }

  //代办事项点击事件
  toggle(e) {
    var item = e.item;
    if(item.done) {

      item.closeTime = '';

    } else {
      item.closeTime = new Date().getTime().toString();
    }

    item.done = !item.done
    return true
  }

</script>

</todo>
