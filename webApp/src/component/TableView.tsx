import React from 'react'; 
import MenuItem from './MenuItem';
import '../stylesheets/TableView.css';

type TableViewState = {
}

type TableViewProps = {
}

class TableView extends React.Component<TableViewProps,TableViewState>{
    render() {
        return(
            <div className="TableView">
                <div className="TableInformation">
                    <div>
                        <h3>
                            # of Patrons: 5
                        </h3>
                        <h3>
                            Total Time: 
                        </h3>
                    </div>
                    <button className="checkout">
                        Checkout 
                    </button>
                </div>
                <div className="menu">
                    <MenuItem 
                    name="Baba Ganoush" 
                    image="https://www.seriouseats.com/recipes/images/2014/02/20140225-baba-ganoush-recipe-food-lab-vegan-primary-3.jpg"
                    status="pending"
                    />
                    <MenuItem 
                    name="Thicc Sandwhich" 
                    image="https://magazine.funnewjersey.com/wp-content/uploads/2018/09/ru-hungry-subs-new-brunswick-nj.jpg"
                    status="working"
                    />
                    <MenuItem 
                    name="Fat Noods" 
                    image="https://www.theflavorbender.com/wp-content/uploads/2019/01/Easy-Chicken-Ramen-Featured.jpg"
                    status="working"
                    />
                    <MenuItem 
                    name="Meat Joint" 
                    image="https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/double-beef-quesarito-1555084460.jpg?crop=0.668xw:1.00xh;0.226xw,0&resize=980:*"
                    status="working"
                    />
                    <MenuItem 
                    name="Lines" 
                    image="https://drugabuse.com/wp-content/uploads/drugabuse-shutterstock220086538-cocaine_feature_image-cocaine.jpg"
                    status="done"
                    />
                </div>
            </div>
        )
    }
}

export default TableView;
