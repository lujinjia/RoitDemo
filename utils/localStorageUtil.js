/**
 * Created by Jim Loo on 2017/9/4 0004.
 * 用户数据持久化
 */

const localStorageUtils =  {
    data : {
        DATA: []
    },

    methods: {

        init(key) {
            var data = JSON.parse(localStorage.getItem(key));
            if(data && data.length) {
                this.DATA = data;
            } else {
                this.DATA = [];
            }
            return this.DATA;
        },

        //mips
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

        updateType(type, items) {
            this.DATA.map((item)=>{

            });
        },

        //根据index删除值
        deleteItem(index) {
            this.DATA.splice(index, 1);
            this.update();

        },

        getIndex(key) {

            var itemIndex;

           this.DATA.map((data, index)=>{
               if(data.id === key) {
                   itemIndex =  index;
               }
            });

           return itemIndex;

        },

        //localStorage增加对象
        addItem(data) {

            var length = 0;
            if(this.DATA.length > 1) {
              length = this.DATA.length;
            }
            data.id = (length).toString();
            this.DATA.push(data);
            this.update();
        },

        //更新值到浏览器
        update() {
            localStorage.setItem('todoItems', JSON.stringify(this.DATA));
        }


    }
};
