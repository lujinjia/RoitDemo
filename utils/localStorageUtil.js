/**
 * Created by Jim Loo on 2017/9/4 0004.
 * 用户数据持久化
 */

const localStorageUtils =  {
    data : {
        DATA: ''
    },

    methods: {

        init(key) {
            this.DATA = JSON.parse(localStorage.getItem(key));
            return this.DATA;
        },

        //
        search() {

        },

        //根据key获取值
        getItem(key) {
            return this.DATA[key];
        },

        //根据key更新值
        setItem(key, data) {
            this.DATA.map((item, value)=>{
                if(value === key) {
                    item = data;
                }
            });
            this.update();
        },

        //根据key删除值
        deleteItem(key) {
            this.DATA.splice(key-1, 1);
            this.update();
        },

        //localStorage增加对象
        addItem(data) {
            data.id = (this.DATA.length + 1).toString();
            this.DATA.push(data);
            this.update();
        },

        //更新值到浏览器
        update() {
            localStorage.setItem('todoItems', JSON.stringify(this.DATA));
        }


    }
};
