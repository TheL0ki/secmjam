{extends 'layout.tpl'}

{block name=title}Add Menu Item - SEC-Mjam{/block}

{block name=content}
    <div class="row mt-3">
        <div class="col-md-6">
            <div class="card">
                <div class="card-header">
                    Add Menu Item
                </div>
                <div class="card-body">
                    <form action="/admin/categories/edit/{$category->id}/menu/create" method="post">
                        <div class="mb-3">
                            <label class="form-label" for="sub_category">Sub Category</label>
                            <input class="form-control" type="text" id="sub_category" name="sub_category">
                        </div>
                        <div class="mb-3">
                            <label class="form-label" for="item">Item</label>
                            <input class="form-control" type="text" id="item" name="item" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label" for="size">Size</label>
                            <input class="form-control" type="text" id="size" name="size" value="-" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label" for="price">Price</label>
                            <input class="form-control" type="number" step="0.01" id="price" name="price" value="0.00" required>
                        </div>
                        <div class="mb-3 d-flex justify-content-between">
                            <button class="btn btn-primary" type="submit">Speichern</button>
                            <a role="button" class="btn btn-secondary" href="/admin/categories/edit/{$category->id}/menu">Abbrechen</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
{/block}
